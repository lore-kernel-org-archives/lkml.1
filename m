Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0CEQEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:04:40 -0500
Received: from light.bluelinux.co.uk ([195.10.223.138]:50622 "EHLO
	light.bluelinux.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab0CEQEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:04:38 -0500
Date: Fri, 5 Mar 2010 18:04:34 +0200
From: Daniel Stone <daniel@fooishbar.org>
To: David Miller <davem@davemloft.net>
Cc: skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [git pull] drm request 3
Message-ID: <20100305160434.GE2505@tempa>
Mail-Followup-To: Daniel Stone <daniel@fooishbar.org>,
	David Miller <davem@davemloft.net>, skeggsb@gmail.com,
	airlied@linux.ie, linux-kernel@vger.kernel.org,
	jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu,
	torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
References: <20100305151754.GB2505@tempa> <20100305.072612.186421758.davem@davemloft.net> <20100305154009.GC2505@tempa> <20100305.074835.159078083.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P+33d92oIH25kiaB"
Content-Disposition: inline
In-Reply-To: <20100305.074835.159078083.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P+33d92oIH25kiaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 05, 2010 at 07:48:35AM -0800, David Miller wrote:
> From: Daniel Stone <daniel@fooishbar.org>
> > On Fri, Mar 05, 2010 at 07:26:12AM -0800, David Miller wrote:
> >> In fact, I argue that the moment nouveau went into Fedora and
> >> was turned on by default, the interfaces needed to be frozen.
> >=20
> > That's a matter for the Fedora kernel team; for better or worse, they
> > made the choices they did, which included going through all the relevant
> > pain to support this.  They didn't consider it suitable for upstream
> > because they didn't think everyone else should be forced to endure that
> > pain.
>=20
> By not merging it upstream the pain is larger not smaller.
>=20
> It's enabled by default, so you therefore can't test upstream kernels
> by default.

'That's a matter for the Fedora kernel team'.

> And as I showed already, even if you jump through the hoops to make it
> work (building noveau from out of tree in the upstream kernel) you'll
> end up getting screwed when the API changes anyways.

So you're saying that there's no way to develop any reasonable body of
code for the Linux kernel without committing to keeping your ABI
absolutely rock-solid stable for eternity, no exceptions, ever? Cool,
that worked really well for Xlib.

> Using VESA or whatever else you've suggested is just not a reasonable
> alternative.
>=20
> You can't unleash something like this on a userbase of this magnitude
> and then throw your hands up in the air and say "I'm not willing to
> support this in a reasonable way."
>=20
> We're better than that.

Your opinion on what constitutes reasonable support is not universal,
absolute truth.

--P+33d92oIH25kiaB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuRK5IACgkQUVYB1rKAgJTUlwCdEfVzDmYJTG4oyCr/CzcEiaxU
0jQAoJ63inbMWBbsPfGL5/K/dr1Ykrke
=rd9q
-----END PGP SIGNATURE-----

--P+33d92oIH25kiaB--
