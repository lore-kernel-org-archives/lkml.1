Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbZIXWSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbZIXWSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZIXWSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:18:46 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42768 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422AbZIXWSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:18:46 -0400
X-Sasl-enc: mvBV8WZBZ1GyKIA2/q957F8kjLHyu0HrJCel1jjXn8it 1253830729
Message-ID: <4ABBF03C.1070309@imap.cc>
Date: Fri, 25 Sep 2009 00:18:36 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.35
References: <20090924173758.GA17077@kroah.com>
In-Reply-To: <20090924173758.GA17077@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCB223F9E9CE10BDB00E7D18A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCB223F9E9CE10BDB00E7D18A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Greg,

I notice the mismerge of mainline commit
170ebf85160dd128e1c4206cc197cce7d1424705
"bas_gigaset: correctly allocate USB interrupt transfer buffer"
into 2.6.27-stable isn't fixed in this release yet. Is that just
a timing problem, or do you still need anything from me?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigCB223F9E9CE10BDB00E7D18A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKu/BEQ3+did9BuFsRAu+EAJwMYIY0ByCmKEOC/ESL3mOJSAiRMQCdHaTV
F6t3MSCEDh5FEPk0S5atmVU=
=MNM0
-----END PGP SIGNATURE-----

--------------enigCB223F9E9CE10BDB00E7D18A--
