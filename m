Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZEEDIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZEEDIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZEEDIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:08:40 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55199 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbZEEDIj (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:08:39 -0400
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
In-Reply-To: Your message of "Mon, 04 May 2009 19:11:21 PDT."
             <20090505021121.GA6982@linux.vnet.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <20090504153815.GB6740@linux.vnet.ibm.com> <20090504155505.GA8822@parisc-linux.org> <20090504161024.GC6740@linux.vnet.ibm.com> <20090504162252.GB8822@parisc-linux.org> <20090504221208.GB29402@kroah.com> <20090505020149.GE8822@parisc-linux.org>
            <20090505021121.GA6982@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1241492901_53910P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 04 May 2009 23:08:21 -0400
Message-ID: <59297.1241492901@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1241492901_53910P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 04 May 2009 19:11:21 PDT, =22Paul E. McKenney=22 said:
=20
> http://www.copyright.gov/circs/circ1.pdf
>=20
> Page 4, bottom of first column through second column.

And that says:

	 The symbol =A9 (the letter C in a circle), or the word
  =22Copyright,=22 or the abbreviation =22Copr.=22 and

The 3 byte sequence ( c ) is different than the UTF-8 character known as
=22U+00A9	c2 a9	COPYRIGHT SIGN=22.  If you can find an actual citation th=
at
the 3-byte sequence c-between-parens has the same legal meaning as c-in-c=
ircle,
bring it on.

--==_Exmh_1241492901_53910P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ/62lcC3lWbTT17ARAtJUAKD9TMv2E+JxLonxhsuAB5KtLk5L9gCg4vsr
gCAp/EEqLvOhXGU9GkS8kMM=
=TWsE
-----END PGP SIGNATURE-----

--==_Exmh_1241492901_53910P--
