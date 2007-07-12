Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbXGLSfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbXGLSfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbXGLSfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:35:43 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33178 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbXGLSfm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:35:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mark Shelby <mshelby1@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel autoconfig option?
In-Reply-To: Your message of "Thu, 12 Jul 2007 10:18:55 EDT."
             <78ecab220707120718q7cfcff43u66f80711c7ec1005@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <78ecab220707120718q7cfcff43u66f80711c7ec1005@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1184265341_3357P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Jul 2007 14:35:41 -0400
Message-ID: <11610.1184265341@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1184265341_3357P
Content-Type: text/plain; charset=us-ascii

On Thu, 12 Jul 2007 10:18:55 EDT, Mark Shelby said:

> Am I just crazy, or wouldn't this idea mke a lot of sense? Wouldn't it
> pretty much make the kernel "idiot proof" when installing from source?

That's usually not the place where idiots screw up.  It's stuff like
loading an initrd that doesn't do LVM, and your / is on an LVM partition,
or going from a kernel that used the IDE drivers to one that uses libata,
and forgetting to fix /etc/fstab for the /dev/hd -> /dev/sd change, or ...

You get the idea.  At some point, you have to insist that the user's clue
must be  ----> THIS TALL in order to build their own kernel rather than going
with what the distro installed.

--==_Exmh_1184265341_3357P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGlnR9cC3lWbTT17ARAmLbAKCsLfXzknT8jXEY0/0q3t22q1d6igCfZI85
RCHL41RMpOUExKJBqWfC2EM=
=1v4c
-----END PGP SIGNATURE-----

--==_Exmh_1184265341_3357P--
