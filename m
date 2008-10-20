Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbYJTMwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbYJTMwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYJTMwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:52:04 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:47543 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYJTMwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:52:02 -0400
Subject: Re: iwl3945 broken in current git
From: Johannes Berg <johannes@sipsolutions.net>
To: Dieter Ries <clip2@gmx.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <48FC7DEC.9060200@gmx.de> (sfid-20081020_144811_359409_AFE17DE7)
References: <48FC6C05.6020901@gmx.de>
	 <20081020121710.GA3607@isilmar.linta.de>
	 (sfid-20081020_141718_690091_E56EF8AB) <1224506010.27899.23.camel@johannes.berg>
	 <48FC7B1A.10307@gmx.de>
	 (sfid-20081020_143609_718157_68144039) <1224506366.27899.25.camel@johannes.berg>
	 <48FC7DEC.9060200@gmx.de> (sfid-20081020_144811_359409_AFE17DE7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5NYKols06RYpaIinV0V1"
Date: Mon, 20 Oct 2008 14:51:57 +0200
Message-Id: <1224507117.27899.29.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5NYKols06RYpaIinV0V1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 14:47 +0200, Dieter Ries wrote:

> ahem, I don't seem to have ef224ca2ce55e81acc6c3a74c3e8c00a00941c70, are
> you sure that is the right hash?

If anything, it's probably f93405206557077d6508682b624117ec68ea48f6, but
the commit messages aren't very enlightening.

johannes

--=-5NYKols06RYpaIinV0V1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/H7qAAoJEKVg1VMiehFYEN4P/1NRCv0I0xVVjCgs9v7BnrYW
IhBD07TsyHOP/5pODhEy90r/mx/OOzXad+Nz26fzUT5tILMudQ2s5ZNiktP4wQLM
qCFk43IMrbMG0H4o/u43G17idQ2tdTODupxLodNx1kL/7peIZHg/J6WJrVYWy/Rh
gqji0PtpRMV8V4VqkpLOgb6vSNccsY1zK3Bn98RD6LDbrSmuuZ1Nr+OQg8nfFya0
6umXT7aJlcggj7k1fpuMX1G2GOq5JJyFmpM1o5PWQsGQbAYMUjrsw+IR3L100xR8
EOOS8LAs6FlDnh+WvMX2qI+U0TjlzsNnW8wSmg57fwCeaGerew8+vvvhPuxVaCZf
u8aRPS1jxEYy6Icr7iEEgpjpT+gon9pxtn9s/HhxlaEWzSLEJWVqHayipAv3Fv8Q
cRODWa2prWMBB6mSYeu6mrUhMplztY2Ysy/NHdj+8NPnBUdB4QjyI785uZZ1H589
vFNMcV5sIxhQabSWCseUfgEx7K6lLogdvnQps98jNDNZO/0Su+RlQyjGkuRXXJmK
v3lW7Jif2xWtEVBFCxQ4OyugXa7Y/M5Ftqpi3G4FaYIfGQdJIaOjJvxncCe26l6S
kFB9KjCpmtv4IhRnRTrFst39nu2RRWl1pQ7qdEqYqlZW6vBHC0eMSjcfKYmOiDXE
21ihyenv3rtNQBcmPTLv
=RnzY
-----END PGP SIGNATURE-----

--=-5NYKols06RYpaIinV0V1--

