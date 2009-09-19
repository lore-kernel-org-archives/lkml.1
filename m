Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbZISPRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbZISPRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 11:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932158AbZISPRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 11:17:30 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52455 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932135AbZISPRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 11:17:30 -0400
X-Sasl-enc: oXyZLY0T9FtyikqyBTmUmQJjMIa3+gIyWS7q7DzuKK/m 1253373453
Message-ID: <4AB4F602.20004@imap.cc>
Date: Sat, 19 Sep 2009 17:17:22 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/20] mem_class: use minor as index instead of searching
  the array
References: <20090915181247.GA32167@kroah.com>	 <1253041976-1111-6-git-send-email-gregkh@suse.de>	 <1253043763.11643.358.camel@desktop>	 <ac3eb2510909151246r59decb10pfb68fd5c0cb9a63a@mail.gmail.com>	 <1253045229.11643.398.camel@desktop> <20090915202445.GC3411@suse.de>	 <1253049491.11643.490.camel@desktop>  <20090915212019.GA6744@suse.de> <1253050006.11643.492.camel@desktop>
In-Reply-To: <1253050006.11643.492.camel@desktop>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBFAE33FAF6CCDC33434F614A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBFAE33FAF6CCDC33434F614A
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 15.09.2009 23:26 schrieb Daniel Walker:
> On Tue, 2009-09-15 at 14:20 -0700, Greg KH wrote:
>=20
>> I'll gladly do that, it's trival for me to do so.
>>
>=20
> What about the other side ? The people who are sending the clean ups,
> there time is valuable too..

Do such people really exist? Nobody ever sent a cleanup patch for any
of the numerous checkpatch errors in drivers/isdn/gigaset. I only get
complaints about them when I submit a patch that touches one of the
affected lines.

SCNR
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigBFAE33FAF6CCDC33434F614A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKtPYKQ3+did9BuFsRAtj9AJ90SOSRTNdOIC3KN2K28oE/fMdnpwCghvCI
cOCJDQ5beWFSi6d6HNJf668=
=iL2V
-----END PGP SIGNATURE-----

--------------enigBFAE33FAF6CCDC33434F614A--
