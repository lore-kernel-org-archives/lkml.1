Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbZD2VnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbZD2VnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZD2Vm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:42:56 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43106 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZD2Vmz (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:42:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Mike Frysinger <vapier.adi@gmail.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.81 release
In-Reply-To: Your message of "Wed, 29 Apr 2009 12:23:09 PDT."
             <20090429192309.GA15539@kroah.com>
From: Valdis.Kletnieks@vt.edu
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> <20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com>
            <20090429192309.GA15539@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1241041373_4397P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Apr 2009 17:42:53 -0400
Message-ID: <44275.1241041373@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1241041373_4397P
Content-Type: text/plain; charset=us-ascii

On Wed, 29 Apr 2009 12:23:09 PDT, Greg KH said:

> Distros ship uppdate-usbids.sh, like they do the same for the pci ids
> file.  And you can consider the usb.ids file a "config file" :)

So my Fedora Rawhide box still has usbutils 0.73.  I go snarf usbutils 0.81
from SourceForge and I find:

[~/src/usbutils-0.81] ls
AUTHORS    Makefile.am  aclocal.m4    depcomp     list.h     missing  usbmisc.c
COPYING    Makefile.in  config.h.in   devtree.c   lsusb-t.c  names.c  usbmisc.h
ChangeLog  NEWS         configure     devtree.h   lsusb.8    names.h
INSTALL    README       configure.ac  install-sh  lsusb.c    usb.ids
[~/src/usbutils-0.81] grep update-usb *
ChangeLog:      * update-usbids.sh: add "-q" (quiet) option for cron jobs;
ChangeLog:      * update-usbids.sh:  add, based on update-pciids.sh
[~/src/usbutils-0.81] 

So it's not in the tarball, and it's apparently not created by the Makefile.

So where is it?

--==_Exmh_1241041373_4397P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ+MndcC3lWbTT17ARAvmjAJsEhrsYKqvanZaIdeVGVYxJTrrSzQCgnP26
C6Lu0XsZekexXhYfcciPjq4=
=TqB0
-----END PGP SIGNATURE-----

--==_Exmh_1241041373_4397P--
