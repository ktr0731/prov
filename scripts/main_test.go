package main

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func Test_sortSlice(t *testing.T) {
	in := []string{"a", "c", "b"}
	expected := []string{"a", "b", "c"}
	sortSlice(in)
	require.Equal(t, expected, in)
}

func Test_toUnique(t *testing.T) {
	in := []string{"a", "b", "b", "c"}
	expected := []string{"a", "b", "c"}
	actual := toUnique(in)
	require.Equal(t, expected, actual)
}
