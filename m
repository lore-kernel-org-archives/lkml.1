Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbXLFXNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbXLFXNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXLFXM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:12:56 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60818 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbXLFXMz (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:12:55 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: device-mapper development <dm-devel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: 2.6.24-rc4-mm1
In-Reply-To: Your message of "Thu, 06 Dec 2007 23:04:12 +0100."
             <3ae72650712061404w170fc434nb1172e048216e139@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <3941.1196941764@turing-police.cc.vt.edu> <20071206040420.6c89c675.akpm@linux-foundation.org> <4374.1196968688@turing-police.cc.vt.edu> <20071206193843.GA25125@kroah.com>
            <3ae72650712061404w170fc434nb1172e048216e139@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196982750_2767P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Dec 2007 18:12:30 -0500
Message-ID: <2955.1196982750@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196982750_2767P
Content-Type: text/plain; charset=us-ascii

On Thu, 06 Dec 2007 23:04:12 +0100, Kay Sievers said:

> What's the value of SYSFS_DEPRECATED? Care to set it to yes, if it isn't,
> and try again?

I *knew* there was a D'Oh! error in here. ;)

Bisection is fast closing in on gregkh-driver-block-device.patch, which broke
my LVM almost the exact same way the *last* time it showed up in -mm ;)

> A fix for LVM to handle symlinks instead of directories is in the LVM
> CVS tree, but there wasn't a release since August.

I seem to recall it was 'nash' rather than LVM that had the indigestion the
last time around.








--==_Exmh_1196982750_2767P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD4DBQFHWIHecC3lWbTT17ARAsxnAJwKiCFyNJqF1edByoMhZ6iLGxrziACUCI8o
STbDgOfily2LZErBZtepNw==
=cxO4
-----END PGP SIGNATURE-----

--==_Exmh_1196982750_2767P--
