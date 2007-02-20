Return-Path: <linux-kernel-owner+w=401wt.eu-S965163AbXBTPrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965163AbXBTPrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965169AbXBTPrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:47:15 -0500
Received: from cdm-75-109-122-87.asbnva.dh.suddenlink.net ([75.109.122.87]:33820
	"EHLO turing-police.cc.vt.edu" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965163AbXBTPrO (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:47:14 -0500
X-Greylist: delayed 1938 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Feb 2007 10:47:14 EST
Message-Id: <200702201514.l1KFEVIE023344@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: v j <vj.linux@gmail.com>, davids@webmaster.com, trent.waddington@gmail.com,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: Your message of "Tue, 20 Feb 2007 12:00:51 +0100."
             <1171969251.12262.16.camel@tara.firmix.at>
From: Valdis.Kletnieks@vt.edu
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com> <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com> <9b3a62ab0702192119l1bf9a284la93c9d1f01638ca4@mail.gmail.com>
            <1171969251.12262.16.camel@tara.firmix.at>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1171984471_20062P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Feb 2007 10:14:31 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1171984471_20062P
Content-Type: text/plain; charset=us-ascii

On Tue, 20 Feb 2007 12:00:51 +0100, Bernd Petrovitsch said:
> Flame bait alert:
> I heard a talk from an Austrian lawyer an according to his believes (and
> I don't know if he is the only one or if there lots of) one must see
> from the "users" view if the GPL spreads over or not (and the usual
> technical terms like "linking" are basically irrelevant).
> E.g.:
> - You are distributing an application which links against a GPL-library.
> If you provide a link and the user/customer has to get and install that
> library, your application can have any license you wish.
> - If you distribute an application and it installs automatically a
> library (e.g. from the CD where your application is installed), your
> applications license must "fit" wit the library license.

So tell me - if RedHat distributes a non-GPL program that uses a GPL
library that is included as part of the distribution, but *not* one that's
usually installed, which rules apply?

Even better - does this mean that I can *intentionally* bypass the licensing by
including a installer script that removed a problematic library, and then
forces the user to re-install it?



--==_Exmh_1171984471_20062P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF2xBXcC3lWbTT17ARArqxAJ9ADzLf9hfkRWFoIvROxauTNNCTygCgrd9T
8baoA6KZAbA88spMdDBpVNg=
=QJAP
-----END PGP SIGNATURE-----

--==_Exmh_1171984471_20062P--
