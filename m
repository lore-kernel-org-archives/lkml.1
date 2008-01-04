Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbYADFmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbYADFmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759003AbYADFmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:42:18 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48028 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759529AbYADFmQ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:42:16 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Eric Anopolsky <erpo41@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, sct@redhat.com, akpm@linux-foundation.org,
       adilger@clusterfs.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
In-Reply-To: Your message of "Wed, 02 Jan 2008 13:51:32 PST."
             <1199310692.5786.53.camel@dione>
From: Valdis.Kletnieks@vt.edu
References: <20080102013218.GO27566@does.not.exist> <20080102174157.GD3351@webber.adilger.int> <20080102195146.GB15898@does.not.exist>
            <1199310692.5786.53.camel@dione>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199425297_4991P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 04 Jan 2008 00:41:37 -0500
Message-ID: <11223.1199425297@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199425297_4991P
Content-Type: text/plain; charset=us-ascii

On Wed, 02 Jan 2008 13:51:32 PST, Eric Anopolsky said:

> their own kernels in the first place. IMHO, it's reasonable to expect
> the small minority of Linux users who want to compile their own kernels
> to learn that "EXPERIMENTAL" means something.

And what, exactly, does it mean, given that there's a bunch of stuff that's
tagged EXPERIMENTAL that's more solid/tested than a lot of stuff that *isn't*
marked with it?

--==_Exmh_1199425297_4991P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHfccRcC3lWbTT17ARAtmXAKDs4mqrhvnW+ht3dOT5lSNu+ZazIACfbZDG
3Zmkfv0FztJybw/6GZo6rko=
=vhof
-----END PGP SIGNATURE-----

--==_Exmh_1199425297_4991P--
