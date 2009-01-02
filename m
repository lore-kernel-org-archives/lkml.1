Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbZABPjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbZABPjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 10:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZABPje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 10:39:34 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:46971 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbZABPje (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 10:39:34 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Bryan Donlan <bdonlan@gmail.com>,
       Ingo Brueckl <ib@wupperonline.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86 (Linux Tiny): configure out support for some processors
In-Reply-To: Your message of "Fri, 02 Jan 2009 20:40:16 +0530."
             <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <495d2974@wupperonline.de> <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com> <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com> <20090102093801.GD1975@elte.hu>
            <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1230910752_3517P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Jan 2009 10:39:12 -0500
Message-ID: <11444.1230910752@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1230910752_3517P
Content-Type: text/plain; charset=us-ascii

On Fri, 02 Jan 2009 20:40:16 +0530, Jaswinder Singh Rajput said:

> If I know what is my CPU there is no point for supporting all related
> CPUs in my kernel.

EMBEDDED is for a large assortment of things, all of which are of the form:

General users won't want to change Y, but if I know I don't need Y, there is
no point in supporting Y in the kernel.

Y might be "this kernel doesn't need sysctl"
Y might be "support for hot-plug"
Y might be "printk"
Y might be "support generic CPUs"

See the pattern?

Yes, we probably could have come up with a better name than EMBEDDED for
that list of optionals.

CONFIG_TRAINED_TECHNICIANS_ONLY_NO_USER_SERVICABLE_PARTS_INSIDE maybe?


--==_Exmh_1230910752_3517P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJXjUgcC3lWbTT17ARAlL9AJ0YtZJRudiy3q+RJKvVvUlbQ4M5MACg48vv
x55Ojm9DNfQY/ztQTHJToYg=
=EHSW
-----END PGP SIGNATURE-----

--==_Exmh_1230910752_3517P--
