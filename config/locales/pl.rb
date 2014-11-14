{
pl: {i18n: {plural: {rule: lambda { |n| n == 1 ? :one : (2..4).include?(n % 10) && !(12..14).include?(n % 100) ? :few : :other }}}}
}
