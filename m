Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZD2WUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZD2WUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbZD2WT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:19:58 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48689 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZD2WT6 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:19:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Mike Frysinger <vapier.adi@gmail.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.81 release
In-Reply-To: Your message of "Wed, 29 Apr 2009 14:56:23 PDT."
             <20090429215623.GA27319@kroah.com>
From: Valdis.Kletnieks@vt.edu
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> <20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com> <20090429192309.GA15539@kroah.com> <44275.1241041373@turing-police.cc.vt.edu>
            <20090429215623.GA27319@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1241043596_4397P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Apr 2009 18:19:57 -0400
Message-ID: <46380.1241043597@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1241043596_4397P
Content-Type: text/plain; charset=us-ascii

On Wed, 29 Apr 2009 14:56:23 PDT, Greg KH said:

> As was pointed out by Mike, a bug in the Makefile prevented it from
> being added to the tarball.

Yeah, I managed to miss that 3-line part of that e-mail some 259 emails back.
Sometimes the LKML firehose sucks. :)

> If youreally want it, you can grab it from the git tree, or wait a day
> or so for me to implement Mike's changes he so nicely sent me, so I can
> do a new release.

Admittedly, it was mostly the sudden "Wait - why isn't there a update-usbids
on my laptop?" panic - at least now I understand what happened.

So I grabbed it from the GIT tree, turns out Fedora is already packaging the
current version of usb.ids as part of the 'hwdata' RPM rather than 'usbutils',
so the practical impact of the whole thing dropped a big chunk.  Still need to
get them to upgrade from 0.73 to 0.82 though.

Thanks for the clue-by-four... ;)


--==_Exmh_1241043596_4397P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ+NKMcC3lWbTT17ARAvEsAJ4wBFF75Dddpl5W/4NnotDlwgAKawCg2Fic
rT7P3+HWmGz40UIhv40sot4=
=VSia
-----END PGP SIGNATURE-----

--==_Exmh_1241043596_4397P--
