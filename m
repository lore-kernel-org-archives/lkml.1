Return-Path: <linux-kernel-owner+w=401wt.eu-S1763730AbYBLSCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763730AbYBLSCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbYBLSC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:02:29 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55721 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848AbYBLSC2 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:02:28 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Marcel Holtmann <marcel@holtmann.org>
Cc: davids@webmaster.com, David Newall <davidn@davidnewall.com>,
       Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
In-Reply-To: Your message of "Sun, 10 Feb 2008 05:50:17 +0100."
             <1202619017.7664.53.camel@violet>
From: Valdis.Kletnieks@vt.edu
References: <MDEHLPKNGKAHNMBLJOLKGEJHKDAC.davids@webmaster.com>
            <1202619017.7664.53.camel@violet>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1202839330_2949P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 12 Feb 2008 13:02:10 -0500
Message-ID: <29562.1202839330@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1202839330_2949P
Content-Type: text/plain; charset=us-ascii

On Sun, 10 Feb 2008 05:50:17 +0100, Marcel Holtmann said:

> go ahead and create an application that uses a GPL only library. Then
> ask a lawyer if it is okay to distribute your application in binary only
> form without making the source code available (according to the GPL).
> 
> http://www.gnu.org/licenses/old-licenses/gpl-2.0-faq.html#IfLibraryIsGPL
> 
> http://www.gnu.org/licenses/old-licenses/gpl-2.0-faq.html#LinkingWithGPL

What happens if I ship a binary-only program that uses *either* a GPL library
or a custom library with the same API?  "If you don't have the Frobozz-Foo
library, you'll have to supply your own work-alike"....

(Note that this is in fact the *usual* case - very few programs actually
check that they are linking against a Genuine GPL(tm) library, they just want
the *API*, so providing a work-alike is sufficient....)

--==_Exmh_1202839330_2949P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHsd8icC3lWbTT17ARAp32AKCjtR+Mh+CIHkH0QLL1L5MqOZu+WACgyM/z
+p4Cid8bNIX3OGAnDAeYtkk=
=MzXq
-----END PGP SIGNATURE-----

--==_Exmh_1202839330_2949P--
