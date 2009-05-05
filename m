Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbZEEIG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbZEEIG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZEEIGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:06:14 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51161 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbZEEIGM (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:06:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: paulmck@linux.vnet.ibm.com
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
In-Reply-To: Your message of "Mon, 04 May 2009 20:34:42 PDT."
             <20090505033442.GB6982@linux.vnet.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <20090504153815.GB6740@linux.vnet.ibm.com> <20090504155505.GA8822@parisc-linux.org> <20090504161024.GC6740@linux.vnet.ibm.com> <20090504162252.GB8822@parisc-linux.org> <20090504221208.GB29402@kroah.com> <20090505020149.GE8822@parisc-linux.org> <20090505021121.GA6982@linux.vnet.ibm.com> <20090505021853.GF8822@parisc-linux.org>
            <20090505033442.GB6982@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1241510758_53910P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 May 2009 04:05:58 -0400
Message-ID: <74785.1241510758@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1241510758_53910P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 04 May 2009 20:34:42 PDT, =22Paul E. McKenney=22 said:

> I am more than happy to let you search the case law on this one.

Ya know, it's that same =22I'll let your lawyers rediscover the stuff tha=
t mine
already found=22 issue that's making this thread a pain.

Case saying (C) *possibly* sufficient (ruling 'c-in-hexagon' was sufficie=
nt):
Videotronics v. Bend Electronics, 586 F.Supp. 478, 481 (D. Nev. 1984)

Case saying it might not be:
Forry v. Neundorfer, 837 F.2d 259, 266 (6th Cir., 1988)

Neundorfer says:

=22Videotronics, Inc. v. Bend Electronics, 586 F.Supp. 478 (D.Nev.1984) h=
eld that
a letter =22C=22 enclosed within a hexagon met the statutory requirements=
, but
suggested in dicta that the symbol =22(C)=22 might not be sufficient beca=
use
parentheses, unlike a hexagon or a circle, would not completely enclose t=
he
=22C=22. Id. at 481. However, if a =22C=22 in a hexagon is sufficient, an=
 argument
exists that a =22C=22 in parentheses is sufficient. Defendants here had a=
ctual
notice of copyright. The trial of this action may provide a better record=
 on
which to finally decide whether the symbol =22(C)=22 is sufficiently simi=
lar to a
=22C=22 in a circle to serve as notice of a copyright. Plaintiff is appar=
ently now
using the =22C=22 in a circle. It may therefore be entitled to rely on 40=
5(a)(2)
even if the earlier symbol was not sufficient.=22

Clear as mud, unless you have a more recent cite. :)

--==_Exmh_1241510758_53910P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ//NmcC3lWbTT17ARAprzAKDtRMwHywpLiVwg1TTdTKYyHSWW/gCgyTgo
NoSVc0m9SJiXDVZAqBKwpBs=
=QXy9
-----END PGP SIGNATURE-----

--==_Exmh_1241510758_53910P--
