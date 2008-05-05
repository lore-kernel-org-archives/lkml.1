Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbYEEUYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbYEEUYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbYEEUXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:23:54 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:35658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308AbYEEUXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:23:53 -0400
Subject: Re: w35und: some more code removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <20080505202057.GB7273@elf.ucw.cz>
References: <20080505200927.GA7273@elf.ucw.cz>
	 <1210018631.4181.29.camel@johannes.berg> <20080505202057.GB7273@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZykVswFS+CkjaGXB1Xr/"
Date: Mon, 05 May 2008 22:23:03 +0200
Message-Id: <1210018983.4181.33.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZykVswFS+CkjaGXB1Xr/
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

Seriously though, we (as inhabitants of linux-wireless) have no context
for these patches, so I hope you're not expecting us to actually look at
them.

johannes

--=-ZykVswFS+CkjaGXB1Xr/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB9spqVg1VMiehFYAQIoGg/+Jlv6fUxbywWBlqaoYkjkRRD8QXVAJBIk
2n4iiFZ9xmoO9Nvhl0OgFf43Ap7Vdb815sZMynJxtGFuetwzDXEaKxzOybXQxuJN
6dYEfNZFE9jTy5BT0rIlgTdvlNjwNmRg1aLC1wl367D38D1FXyxNZ3GE7TIXiaDF
iSCOgZUjACCqa2lLt2wqUheoaD87RIs1BWJj6Qo3WDla35ihqVQVsKpCVgfGjfCx
b0daElktDFncnh1A1sDVwgUdDP53HF+VGIs5J/aRFmx0YzviK7J6D3pDBt5DeVCu
QPwlf/xtBnw6HE8vK616v/JDTFtvl9pnes4glai0s8vbAFS3rAbAIfX68dNDtZl7
Co4t7QnRu3JyyzeGDIS14OlMLtU1LJiDQEyMZyO+OAUf9XbZtz7nOZQv5W4JyX5i
zjENMazFOsSPrxF7fFDwSyzoCQ12TxfHuvo+a1b1hP2MA5MOnrNqgvZNeDOT+Rtn
7DMZQS3/M+6yObyYt+D0aoKzhERvLnZFfu8VxBx25OdbQ7E+PBvBlEz0pI/aw0Lp
HSwB3MOMrzIaXpKeOSCDAS+MZTkZ4+Ai4Fa8eDicQ6iVfEBWNVnXIqGRtNGrAOdF
bGGL+jIsxIwMy+mYxMGMxzT3dnnvSe86uUfeM9bRNDcX1HR3P8I6T+RHTAXcfRxG
kXF/9QGYl2E=
=BCTn
-----END PGP SIGNATURE-----

--=-ZykVswFS+CkjaGXB1Xr/--

