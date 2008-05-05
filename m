Return-Path: <linux-kernel-owner+w=401wt.eu-S1761894AbYEEV2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761894AbYEEV2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762230AbYEEV1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:27:47 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:49684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761572AbYEEV1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:27:45 -0400
Subject: Re: w35und: some more code removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <20080505202057.GB7273@elf.ucw.cz> (sfid-20080505_221934_472944_3E54F274)
References: <20080505200927.GA7273@elf.ucw.cz>
	 <1210018631.4181.29.camel@johannes.berg> <20080505202057.GB7273@elf.ucw.cz>
	 (sfid-20080505_221934_472944_3E54F274)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ihpNM8pQPoIRPWTpSNit"
Date: Mon, 05 May 2008 23:26:27 +0200
Message-Id: <1210022787.8012.0.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ihpNM8pQPoIRPWTpSNit
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-05 at 22:21 +0200, Pavel Machek wrote:
> On Mon 2008-05-05 22:17:11, Johannes Berg wrote:
> > On Mon, 2008-05-05 at 22:09 +0200, Pavel Machek wrote:
> > > Remove some more unneccessary code
> > >=20
> > > ---
> > > commit 5b251c6315097d5f9ab5d30c43813fe74c1db4e4
> > > tree 5ca21582f55886d5f0249f7ca139687450024581
> > > parent e44ccdabb97fa4a6cdc1a95adcad7bcc469d0c16
> > > author Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:08:51 +0200
> > > committer Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:08:51 +0200
> >=20
> > Let me guess, you're using git-am too? :P
>=20
> No, this is actually all hand-generated ;-).

You must be very bored ;) The delme.gz patch creates like a million
empty files :)

johannes

--=-ihpNM8pQPoIRPWTpSNit
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB97gqVg1VMiehFYAQI7gRAAlV/EOKGYGLSy2zsEbWZQ/ZkuG0IQlanv
qxa2sZFwayxAuXCLl5C3NCgMVp7fQM37udKlNAfWihsR1xEFPPGfuMKm+oLj8ASf
khu6o2WUsLEEiheuGtZFsBvzAMbpLIiHnEndg+xRQHxylHdfVOTXFjRIpDv2nu12
R/mGK2uqREnG+++03q8525Cp0yME9KyBJBDeQxJm6cJkEDDQdNeKDVJJr8QaZKd7
6lWRlI//gb007iwCa1qY0b76/1Sm/BKDZLadE2dkuc0whfqePGmFPxtHv6Ch1Eeu
DvTdzFom5ZUpJKE6w6F5hnx5+eACKvCZ7MEXpv46IEqzQkMzEu20ekC2WYuNwRaX
hwXdnBuap5lG7PffPzlDQzqhCxYKYX0aKgs6zmQsFHQyntAXGDVtZjVsf4xtaUc9
/O+5tjqDn5lXmFn/Jb8cX+QmhJs7KqtpO6xIDdQkBPyFNfmGnX5XecjaK9S45LfG
EniE4L8vq154N6GdnrNiVyNTTFLAyCqTAfyiOBGG5EVAzB6JYFNaB8OLSoAacxfd
dLnjw6Mrf9MTa3BWLd2dSAZwxQTWmFAFY6v4Yc/WYXnbN5Dh3O+cmqvicfAOT+xB
lKpRtQ+K8VnF1hHBywVO7H4XccCvxD4XoiCmUZuaA5kuajag0gqWn/fGJvuMHriU
7i63GVA+Og8=
=mmej
-----END PGP SIGNATURE-----

--=-ihpNM8pQPoIRPWTpSNit--

