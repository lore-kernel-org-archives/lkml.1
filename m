Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbXEUPxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbXEUPxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbXEUPxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:53:09 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:52310 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbXEUPxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:53:08 -0400
Date: Mon, 21 May 2007 17:53:02 +0200
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 4/8] Force detect and enable HPET on ICH
Message-ID: <20070521175302.28b33ac7@laptop.hypervisor.org>
In-Reply-To: <200705210846.03540.jbarnes@virtuousgeek.org>
References: <20070507203128.GD3926@linux-os.sc.intel.com>
	<20070521025822.506c3287@laptop.hypervisor.org>
	<200705210846.03540.jbarnes@virtuousgeek.org>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_iyZmDCR.o.QYkFniXOXfdsY;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_iyZmDCR.o.QYkFniXOXfdsY
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 21 May 2007 08:46:03 -0700 Jesse Barnes (JB) wrote:

JB> I see it documented in the ICH5 datasheet, but that bit is marked reser=
ved=20
JB> in the ICH3 and ICH4 datasheets...  Which docs are you looking at?

It's documented for ICH5 only. My experiments on IBM T30 (ICH3) and T41p (I=
CH4)
laptops show that HPET exists on these chipsets as well and can be enabled =
the
same way as described in the ICH5 datasheet.

Cheers,

	- Udo

--=20
Dipl.-Inf. Udo Steinberg                    =20
Technische Universit=E4t Dresden               http://os.inf.tu-dresden.de/=
~us15
Institute for System Architecture            Tel: +49 351 463 38401
D-01062 Dresden                              Fax: +49 351 463 38284

--Sig_iyZmDCR.o.QYkFniXOXfdsY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGUcBenhRzXSM7nSkRAl0bAJ9ScZmEoiAB2NR6hruB8XSMWvyBMwCeL2Nl
ptALH1FulwBSjYSfbSXuI8U=
=y16R
-----END PGP SIGNATURE-----

--Sig_iyZmDCR.o.QYkFniXOXfdsY--
