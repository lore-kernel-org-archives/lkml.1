Return-Path: <linux-kernel-owner+w=401wt.eu-S1751807AbZG3SkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbZG3SkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 14:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbZG3SkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 14:40:23 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34398 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZG3SkW (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 14:40:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Gene Heskett <gene.heskett@verizon.net>
Cc: Frans Pop <elendil@planet.nl>, alan@lxorguk.ukuu.org.uk,
       torvalds@linux-foundation.org, hirofumi@mail.parknet.co.jp,
       aneesh.kumar@linux.vnet.ibm.com, rjw@sisk.pl, ray-lk@madrabbit.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       stern@rowland.harvard.edu
Subject: Re: [PATCH] kdesu broken
In-Reply-To: Your message of "Thu, 30 Jul 2009 11:35:03 EDT."
             <200907301135.03509.gene.heskett@verizon.net>
From: Valdis.Kletnieks@vt.edu
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <200907291519.19567.gene.heskett@verizon.net> <28783.1248957815@turing-police.cc.vt.edu>
            <200907301135.03509.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248979154_3306P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Jul 2009 14:39:14 -0400
Message-ID: <25546.1248979154@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248979154_3306P
Content-Type: text/plain; charset=us-ascii

On Thu, 30 Jul 2009 11:35:03 EDT, Gene Heskett said:
> Humm, kewl.  And the src's for grubby are where?  Hopefully in C so thois old
> fart can grok...

% rpm -qi grubby

should provide pointers for the .src.rpm and the upstream source...

(That trick should work for *every* RPM - if you find one it doesn't work
for, that's probably a reportable bug to RedHat.)

--==_Exmh_1248979154_3306P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKcejScC3lWbTT17ARAt9PAJkBUz+fb8fnLO3Al2N7QJdnTcfB/ACgpDjb
F/HIui2eUNXbldlKtA0/cf4=
=76bt
-----END PGP SIGNATURE-----

--==_Exmh_1248979154_3306P--
