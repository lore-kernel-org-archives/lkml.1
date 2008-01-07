Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbYAGVno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbYAGVno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 16:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYAGVne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 16:43:34 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38458 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbYAGVnd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 16:43:33 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: devzero@web.de
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: =?iso-8859-15?Q?Re:_[patch_1/2]_show_being-loaded/being-unloaded_indic?= =?iso-8859-15?Q?ator_for_modules?=
In-Reply-To: Your message of "Mon, 07 Jan 2008 11:09:23 +0100."
             <90564384@web.de>
From: Valdis.Kletnieks@vt.edu
References: <90564384@web.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199742204_2703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Jan 2008 16:43:24 -0500
Message-ID: <22332.1199742204@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199742204_2703P
Content-Type: text/plain; charset=us-ascii

On Mon, 07 Jan 2008 11:09:23 +0100, devzero@web.de said:

> but i wonder if some mandatory "print a message on init/exit

With a 'printk(LOG_DEBUG,...' please.  Boot with initcall_debug sometime to
see why. ;)

--==_Exmh_1199742204_2703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHgpz8cC3lWbTT17ARAsuzAKDj1O1hSa0rgEgmtkeN34Pwyp2+UwCg/oPp
IaYegVbqukt5+hkGPQNZVdc=
=bT92
-----END PGP SIGNATURE-----

--==_Exmh_1199742204_2703P--
