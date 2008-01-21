Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYAUSbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYAUSbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 13:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYAUSbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 13:31:22 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58024 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYAUSbW (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 13:31:22 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc8-mm1 - SELinux issues
In-Reply-To: Your message of "Thu, 17 Jan 2008 02:35:14 PST."
             <20080117023514.9df393cf.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200940277_2778P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 21 Jan 2008 13:31:17 -0500
Message-ID: <6117.1200940277@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200940277_2778P
Content-Type: text/plain; charset=us-ascii

On Thu, 17 Jan 2008 02:35:14 PST, Andrew Morton said:

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
> 
> - selinux is busted on one of my two selinux-enabled test machines.

This problem is fixed in Paul Moore's latest spin of the networking patches - I
was able to quilt up a fixed-up -rc8-mm1 with an updated git-lblnet.patch built
from his latest patch-bomb (labelled as 'RFC PATCH v12' posted to the selinux
and linux-security-module lists on Thursday, so the next pull of that git tree
into -mm should be OK...




--==_Exmh_1200940277_2778P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHlOT1cC3lWbTT17ARAsyDAJ0cdn+O+P/ob+apvMQ81/KE13kjBgCguH92
OfUk4qI7NH3Gzn4nnWx7TYg=
=pNLj
-----END PGP SIGNATURE-----

--==_Exmh_1200940277_2778P--
