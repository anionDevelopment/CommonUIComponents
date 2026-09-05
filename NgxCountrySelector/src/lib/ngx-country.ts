/**
 * One country the user can choose: its code and its english name.
 */
export interface NgxCountry {

  /**
   * The two-letter-code of the country as ISO 3166-1 defines it, in upper case - for example "DE", "GB" or "JP".
   * This is the value which `countrySelected` emits.
   */
  code: string;

  /** The english name of the country, for example "Germany". */
  name: string;
}

/**
 * The flag of the country with the code `code` as an emoji, derived from that code rather than shipped as a
 * picture.
 *
 * A flag-emoji is nothing but the two letters of the country-code written as "regional indicator symbols", the
 * letters A to Z at code-point 0x1F1E6 and upwards; every system draws the pair of them as the flag it knows for
 * that country. Deriving it has three consequences which a picture would not have: nothing has to be licensed,
 * nothing has to be updated when a flag changes, and a country whose flag a system does not know simply shows the
 * two letters instead of a broken image.
 *
 * Something which is not a two-letter-code has no flag; the result is an empty text then.
 */
export function flagOf(code: string): string {
  if (code.length !== 2) {
    return '';
  }
  const firstRegionalIndicator = 0x1f1e6;
  const a = 'A'.charCodeAt(0);
  const letters: number[] = [...code.toUpperCase()].map((letter) => firstRegionalIndicator + letter.charCodeAt(0) - a);
  return String.fromCodePoint(...letters);
}

/**
 * What is shown for `country`: its flag and its english name.
 */
export function labelOf(country: NgxCountry): string {
  return `${flagOf(country.code)} ${country.name}`;
}
