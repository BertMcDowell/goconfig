package conf

import (
	"strconv"
	"testing"
)

const confFile = `
[default]
host = example.com
port = 43
compression = on
active = false
array0 = value1
array1 = value1, value2
array2 = value1, value with spaces2

[service-1]
port = 443
`

//url = http://%(host)s/something

type stringtest struct {
	section string
	option  string
	answer  string
}

type stringarraytest struct {
	section string
	option  string
	answer  []string
}

type inttest struct {
	section string
	option  string
	answer  int
}

type booltest struct {
	section string
	option  string
	answer  bool
}

var testSet = []interface{}{
	stringtest{"", "host", "example.com"},
	stringarraytest{"default", "array0", []string{"value1"}},
	stringarraytest{"default", "array1", []string{"value1", "value2"}},
	stringarraytest{"default", "array2", []string{"value1", "value with spaces2"}},
	inttest{"default", "port", 43},
	booltest{"default", "compression", true},
	booltest{"default", "active", false},
	inttest{"service-1", "port", 443},
	//stringtest{"service-1", "url", "http://example.com/something"},
}

func TestBuild(t *testing.T) {
	c, err := ReadConfigBytes([]byte(confFile))
	if err != nil {
		t.Error(err)
	}

	for _, element := range testSet {
		switch element.(type) {
		case stringtest:
			e := element.(stringtest)
			ans, err := c.GetString(e.section, e.option)
			if err != nil {
				t.Error("c.GetString(\"" + e.section + "\",\"" + e.option + "\") returned error: " + err.Error())
			} else if ans != e.answer {
				t.Error("c.GetString(\"" + e.section + "\",\"" + e.option + "\") returned incorrect answer: " + ans)
			}
		case stringarraytest:
			e := element.(stringarraytest)
			ans, err := c.GetStringArray(e.section, e.option)
			if err != nil {
				t.Error("c.GetStringArray(\"" + e.section + "\",\"" + e.option + "\") returned error: " + err.Error())
			} else {
				if len(ans) != len(e.answer) {
					t.Error("c.GetStringArray(\"" + e.section + "\",\"" + e.option + "\") returned incorrect number of elements ")
				} else {
					for i := 0; i < len(ans); i++ {
						if ans[i] != e.answer[i] {
							t.Error("c.GetStringArray(\"" + e.section + "\",\"" + e.option + "\") returned mismatched element: " + e.answer[i] + " != " + ans[i])
						}
					}
				}
			}
		case inttest:
			e := element.(inttest)
			ans, err := c.GetInt(e.section, e.option)
			if err != nil {
				t.Error("c.GetInt(\"" + e.section + "\",\"" + e.option + "\") returned error: " + err.Error())
			} else if ans != e.answer {
				t.Error("c.GetInt(\"" + e.section + "\",\"" + e.option + "\") returned incorrect answer: " + strconv.Itoa(ans))
			}
		case booltest:
			e := element.(booltest)
			ans, err := c.GetBool(e.section, e.option)
			if err != nil {
				t.Error("c.GetBool(\"" + e.section + "\",\"" + e.option + "\") returned error: " + err.Error())
			} else if ans != e.answer {
				t.Error("c.GetBool(\"" + e.section + "\",\"" + e.option + "\") returned incorrect answer")
			}
		}
	}
}
