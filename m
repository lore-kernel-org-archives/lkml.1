Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbXIUAw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbXIUAw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 20:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbXIUAwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 20:52:21 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56781 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256AbXIUAwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 20:52:20 -0400
X-Sasl-enc: xqFFhikEEeFM7Ot9doMAADjM5XbisNECyibVkVMxUVXC 1190335939
Message-ID: <46F31603.1030901@imap.cc>
Date: Fri, 21 Sep 2007 02:53:23 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.23-rc6-mm1
References: <20070918011841.2381bd93.akpm@linux-foundation.org>	<46F1AA6E.1030708@imap.cc>	<46F2C7F8.3040409@imap.cc> <20070920132506.27195aaa.akpm@linux-foundation.org>
In-Reply-To: <20070920132506.27195aaa.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig181AE7F1AC6437BB6439F9F1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig181AE7F1AC6437BB6439F9F1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 20.09.2007 22:25 schrieb Andrew Morton:
> There was a locking imbalance in the IPC code.  Do you have the fixes i=
n
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc=
6/2.6.23-rc6-mm1/hot-fixes/
> applied?

I hadn't. Now that I have, all the troubles are gone. X comes up
fine, and all of the segfault/invalid context/scheduling while atomic
messages have disappeared.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig181AE7F1AC6437BB6439F9F1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG8xYDMdB4Whm86/kRAo8wAJwMLZxT8Nyx0WvMlBgrrvjdHJEqHACfb8EN
eqXh2hWxOLNf1XTEx8ducnU=
=q65e
-----END PGP SIGNATURE-----

--------------enig181AE7F1AC6437BB6439F9F1--
