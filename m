Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbZLOEgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbZLOEgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZLOEgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:36:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47141 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbZLOEga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:36:30 -0500
Date: Tue, 15 Dec 2009 15:36:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: Re: linux-next: rr tree build failure
Message-Id: <20091215153619.1c2e813a.sfr@canb.auug.org.au>
In-Reply-To: <200912151422.29906.rusty@rustcorp.com.au>
References: <20091211122648.8b305b52.sfr@canb.auug.org.au>
	<20091214153528.e29f33a6.sfr@canb.auug.org.au>
	<200912151422.29906.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Dec_2009_15_36_19_+1100_4V23i/3NgCQtJdmB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Dec_2009_15_36_19_+1100_4V23i/3NgCQtJdmB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Tue, 15 Dec 2009 14:22:29 +1030 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> On Mon, 14 Dec 2009 03:05:28 pm Stephen Rothwell wrote:
> >=20
> > The cpufreq patch above is now in Linus' tree, so You should add the
> > patch below to your tree (or squash it into the affected patch).
>=20
> Thanks, done and rebased.

Great, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Dec_2009_15_36_19_+1100_4V23i/3NgCQtJdmB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksnEkMACgkQjjKRsyhoI8yJbACgtSTriPhAdOF/XYNp+4M/jOh+
WVQAoL5sON0TfSrPzPWfYXZAbsU3KcVV
=NrmD
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Dec_2009_15_36_19_+1100_4V23i/3NgCQtJdmB--
