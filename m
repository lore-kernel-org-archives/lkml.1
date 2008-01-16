Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbYAPDvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbYAPDvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbYAPDuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:50:51 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56755 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYAPDuu (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:50:50 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: caglar@pardus.org.tr
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt2
In-Reply-To: Your message of "Tue, 15 Jan 2008 02:37:37 +0200."
             <200801150237.44029.caglar@pardus.org.tr>
From: Valdis.Kletnieks@vt.edu
References: <1200336080.318.8.camel@localhost.localdomain>
            <200801150237.44029.caglar@pardus.org.tr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200455417_2966P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Jan 2008 22:50:17 -0500
Message-ID: <24149.1200455417@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200455417_2966P
Content-Type: text/plain; charset=us-ascii

On Tue, 15 Jan 2008 02:37:37 +0200, =?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur said:
> And because of mcount-add-basic-support-for-gcc-profiler-instrum.patch, closed
> source nvidia-new module cannot be used with this release (mcount is exported
> GPL only), i know this is not supported but i used it with that [2] patch up
> until now without a single problem.

Playing devil's advocate here - the claim is that EXPORT_SYMBOL_GPL is to
indicate that code is getting too chummy with Linux internals.

However, in *this* case, isn't it "code that is too chummy with *GCC* internals",
and thus it isn't our place to say what can and can't be done with code that
is derivative of the GCC compiler? ;)

--==_Exmh_1200455417_2966P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHjX75cC3lWbTT17ARAklbAJ9fOrubFIXeSaMtF97YL2rnH3c0awCgrHb4
VblFYzWX7B+X0P/pGW+ZvEw=
=CbCr
-----END PGP SIGNATURE-----

--==_Exmh_1200455417_2966P--
