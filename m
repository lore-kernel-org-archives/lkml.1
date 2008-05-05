Return-Path: <linux-kernel-owner+w=401wt.eu-S1762435AbYEEVcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762435AbYEEVcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbYEEVcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:32:16 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39666 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbYEEVcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:32:15 -0400
Subject: Re: w35und: driver now down to 16Kloc, and actually works a bit
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <1210021369.4181.43.camel@johannes.berg> (sfid-20080505_232629_125911_14743E12)
References: <20080505210138.GE7273@elf.ucw.cz>
	 (sfid-20080505_230048_056688_3BEEDCE8)  <1210021369.4181.43.camel@johannes.berg>
	 (sfid-20080505_232629_125911_14743E12)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TLVKADRIM/nEMUe1U54i"
Date: Mon, 05 May 2008 23:31:30 +0200
Message-Id: <1210023090.8012.2.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TLVKADRIM/nEMUe1U54i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-05 at 23:02 +0200, Johannes Berg wrote:
> On Mon, 2008-05-05 at 23:01 +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > Ok, code is still extremely ugly, but at least it uses softmac (and
>=20
> why not mac80211? softmac has been deleted

Never mind, a peek inside tells me it does use mac80211.

However, the code gives me the creeps so I won't look any further.

johannes

--=-TLVKADRIM/nEMUe1U54i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB98saVg1VMiehFYAQKExg//fkQ534s1+SD2K+8dnxEGy4K+4+B6c4ek
X6r0mfl7gjmlRgTCjZvqaP8ckZ6vWV9dtprmPwHxdPlZrv5RZL7O6jS3DOTmWpg9
kRl/Ky/IsyTfAiHi+DnWI1VlXNH3erqaIZuh7bWsXfVoKzaYLqNfTH+bfKZs4ZEP
GpqIqNHFoiNu+UMxYMci7br5/JfBXWjOIN18mUk0g2G9610v7N5kpiUFwJ4EEte1
9BPYS3NNPBWV/Y9UdtJyeX2gdbwtgQahDqKg06yQCENYvvA2B149/hPD/tNKxg/j
TVPHFzRZzfmecIkz/ehfSXrGKVAa/5OIP3KH+oaveoFetdUegadMyDwV280yKATl
Cafx87FfpnZCf5k+vC82MoKDuKqkCbr7fL9sS7i6tqZ/wPljdRR3wQWjf4aoxWHS
FCET874WroNVSLtcaGKm/5o/rPjL1bGsZXuWCdJWdlGX1i6VLJq5hHPM/tST+uRd
JjoJhU88DCnemQfzkviFMahGMueMTne03FRIkO8196xFGNMTYuGiR5DltVbM0s3A
XrpKOW5zTn0vj0733bA6dG5XVxsYDe9zkOuISPyyDbYF7krAGmSb4mgnuHBnEaPj
avRb9e5hesz6UHyDBzxkjsXUJpvdZjBGclO/wuncqqpEc8SEYIHRSzhV1yFURRYp
tIgOOUm86XA=
=LBDi
-----END PGP SIGNATURE-----

--=-TLVKADRIM/nEMUe1U54i--

