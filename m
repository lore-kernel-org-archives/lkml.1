Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbZG3OTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbZG3OTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZG3OTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:19:02 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44391 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZG3OTB (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:19:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Gene Heskett <gene.heskett@verizon.net>
Cc: Frans Pop <elendil@planet.nl>, alan@lxorguk.ukuu.org.uk,
       torvalds@linux-foundation.org, hirofumi@mail.parknet.co.jp,
       aneesh.kumar@linux.vnet.ibm.com, rjw@sisk.pl, ray-lk@madrabbit.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       stern@rowland.harvard.edu
Subject: Re: [PATCH] kdesu broken
In-Reply-To: Your message of "Wed, 29 Jul 2009 15:19:19 EDT."
             <200907291519.19567.gene.heskett@verizon.net>
From: Valdis.Kletnieks@vt.edu
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <200907291443.13983.gene.heskett@verizon.net> <200907292108.15839.elendil@planet.nl>
            <200907291519.19567.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248957815_2641P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Jul 2009 08:43:35 -0400
Message-ID: <28783.1248957815@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248957815_2641P
Content-Type: text/plain; charset=us-ascii

On Wed, 29 Jul 2009 15:19:19 EDT, Gene Heskett said:

> Whenever I let rpm get access to my grub.conf, I always have to go back in 
> with vim & fix the stanza numbers I keep track of the boots with.  Grub 
> doesn't really care, but I do. :)  rpm should be so neat...

Just to be accurate - this isn't rpm's fault, it's a program called 'grubby'.

I understand the reasoning - if you just installed a new kernel, you probably
want it to be the one started at next boot.  But it would be nice if grubby
had a configure option for that in /etc/sysconfig/grubby or someplace...

--==_Exmh_1248957815_2641P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKcZV3cC3lWbTT17ARArJ0AKDRd4elMVRcnDI3BF3eQZAmkPhGVQCfRK8z
z4wK2LJUlHvAd3eF+y+3aF4=
=EkoT
-----END PGP SIGNATURE-----

--==_Exmh_1248957815_2641P--
