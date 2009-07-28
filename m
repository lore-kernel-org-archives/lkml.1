Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbZG1QtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbZG1QtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZG1QtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:49:22 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35320 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZG1QtU (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:49:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 31-rc3-mmotm0716 - dead USB trackball mouse kills entire system
In-Reply-To: Your message of "Tue, 28 Jul 2009 10:33:46 EDT."
             <Pine.LNX.4.44L0.0907281031020.2881-100000@iolanthe.rowland.org>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.44L0.0907281031020.2881-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248799741_10289P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Jul 2009 12:49:01 -0400
Message-ID: <15436.1248799741@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248799741_10289P
Content-Type: text/plain; charset=us-ascii

On Tue, 28 Jul 2009 10:33:46 EDT, Alan Stern said:
> A question for you: Do you now observe any warnings in the dmesg log if
> you rmmod ehci-hcd after the trackball mouse is gone?  Apparently the 
> patch you tested isn't perfect and some stuff gets leaked.  I'm trying 
> to track down the problem.

Hmm.. Let me go cook up a test kernel - I have ehci-hcd built-in rather
than a module.  Might take a day or two...

--==_Exmh_1248799741_10289P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKbyv9cC3lWbTT17ARApUoAKDf18OCRDahMphQ4fvL4u2NbntyqACgoWZF
PfWuOJLKXF1NOm62DzihXW8=
=zrki
-----END PGP SIGNATURE-----

--==_Exmh_1248799741_10289P--
