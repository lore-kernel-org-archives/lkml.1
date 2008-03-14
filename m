Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbYCNAfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbYCNAfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYCNAff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:35:35 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34701 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612AbYCNAfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:35:34 -0400
X-Sasl-enc: 9DJo6p/z6IEIc4GI0/3HoqwO3mwo47itnjW5D0NBQcFk 1205454933
Message-ID: <47D9C853.3040701@imap.cc>
Date: Fri, 14 Mar 2008 01:35:31 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>	 <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>
In-Reply-To: <1205441216.4971.65.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig27C3B54164DA4A35B5A10703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig27C3B54164DA4A35B5A10703
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Dave,

On 13.03.2008 21:46 you wrote:
> Could you send me your full dmesg along with your kernel .config?  i
> think this is an ordering issue in bootup, but I'd like to be sure.
> Bonus points if I can also have your initrd. :)

And later:

> If you can send me your vmlinux (not vmlinuz), I'll see how the
> initcalls are laid out in it.

Ok, you asked for it. Find the lot at:

http://gollum.phnxsoft.com/~ts/linux/

I guess you know what to expect, sizewise. :-)

(Don't worry about the cpufreq.debug note, that's for a different issue.)=


> What distro and compiler are you on?

openSUSE 10.3 and the toolchain it brought along, including GCC 4.2.1.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig27C3B54164DA4A35B5A10703
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH2chTMdB4Whm86/kRAlwEAJ4ucoirfQJVSFv5X5bEweblA5GUtwCcD2sI
Uxm1jCofRGMVbVdaENs73Oo=
=zBfj
-----END PGP SIGNATURE-----

--------------enig27C3B54164DA4A35B5A10703--
