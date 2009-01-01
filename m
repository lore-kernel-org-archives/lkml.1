Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZABCQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZABCQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 21:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbZABCQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 21:16:32 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58011 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbZABCQb (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 21:16:31 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-12-30-16-05 uploaded
In-Reply-To: Your message of "Tue, 30 Dec 2008 16:06:00 PST."
             <200812310006.mBV060iV029753@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1230843108_17789P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Jan 2009 15:51:48 -0500
Message-ID: <22921.1230843108@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1230843108_17789P
Content-Type: text/plain; charset=us-ascii

On Tue, 30 Dec 2008 16:06:00 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2008-12-30-16-05 has been uploaded to


  CC =5BM=5D  drivers/misc/dell-laptop.o
drivers/misc/dell-laptop.c: In function dell_send_request:
drivers/misc/dell-laptop.c:147: error: implicit declaration of function dcdbas_smi_request

Fix: move misc-add-dell-laptop-driver.patch to someplace below
dcdbas-export-functionality-for-use-in-other-drivers.patch in the series file.



--==_Exmh_1230843108_17789P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJXSzkcC3lWbTT17ARAqVRAKCfjRSUQTe/Rh/4iQjf7jC+K1ALggCfZAT6
uItc9hzaBXc8ugcxHWcjx8M=
=rkVE
-----END PGP SIGNATURE-----

--==_Exmh_1230843108_17789P--
