Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0BBLz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 06:55:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60964 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab0BBLzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:55:53 -0500
Date: Tue, 2 Feb 2010 22:55:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: sound tree build failure
Message-Id: <20100202225545.84a4fa84.sfr@canb.auug.org.au>
In-Reply-To: <20100202113424.GH6566@rakim.wolfsonmicro.main>
References: <20100202124711.d8cdc220.sfr@canb.auug.org.au>
	<20100202102609.GA6566@rakim.wolfsonmicro.main>
	<20100202213732.586a3566.sfr@canb.auug.org.au>
	<20100202105800.GE6566@rakim.wolfsonmicro.main>
	<20100202221743.1dbcad11.sfr@canb.auug.org.au>
	<20100202113424.GH6566@rakim.wolfsonmicro.main>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Feb_2010_22_55_45_+1100_1J/Ij.PY5g=A0AJO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Feb_2010_22_55_45_+1100_1J/Ij.PY5g=A0AJO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Tue, 2 Feb 2010 11:34:24 +0000 Mark Brown <broonie@opensource.wolfsonmic=
ro.com> wrote:
>
> The way I've always read that was that you'd found a build failure in
> a given bit of the tree while testing -next - you're clearly doing some
> work to identify and understand where the failure came from (and simply
> looking at the source file leads to the same result normally anyway) so
> the fact that you've identified the subsystem doesn't automatically say
> that this happened with a partially merged -next.  If you looked less
> like a human the subject by itself would be clearer :)

How about "linux-next: build failure after merging xxx tree"?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Feb_2010_22_55_45_+1100_1J/Ij.PY5g=A0AJO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktoEsEACgkQjjKRsyhoI8wUOwCdHjK5FPDGtfcKA/cTmpkuknFa
yB0AnA35C+04nUvztlB49TUlVEHJswJn
=kmhi
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Feb_2010_22_55_45_+1100_1J/Ij.PY5g=A0AJO--
