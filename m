Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbXDQNNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbXDQNNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXDQNNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:13:14 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:4664 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbXDQNNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:13:12 -0400
X-Greylist: delayed 1179 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2007 09:13:12 EDT
Message-ID: <4624C320.3050206@imap.cc>
Date: Tue, 17 Apr 2007 14:52:48 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       i4ldeveloper@listserv.isdn4linux.de, Karsten Keil <kkeil@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: so what *is* obsolete and removable?
References: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>	<4623FB0E.4080602@imap.cc> <20070416161337.d59f2ea3.randy.dunlap@oracle.com>
In-Reply-To: <20070416161337.d59f2ea3.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB6A0C849C4890BC4CF3CB99F"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB6A0C849C4890BC4CF3CB99F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Apr 2007 16:13:37 -0700, Randy Dunlap wrote:
> On Tue, 17 Apr 2007 00:39:10 +0200 Tilman Schmidt wrote:
>=20
>> We *did* reach a consensus that isdn4linux is not obsolete in the
>> accepted sense of the word, because there is no replacement for it
>> so far.
>>=20
>> OTOH I have since submitted (twice, in fact) a patch that would remove=

>> the "(obsolete)" label from the Kconfig entry, but somehow nothing
>> ever became of it. My submissions just linger in LKML, uncommented and=

>> unmerged.
>=20
> Did you submit the patch to Andrew Morton?

No. The recipients I chose were Karsten Keil as the subsystem
maintainer, i4ldeveloper as the subsystem specific list, and LKML.

> Is the patch in the -mm patchset?

No. Should it be? It's not as if there was anything to test.
It's purely a textual change in Kconfig messages.

> Did Karsten ack the patch?

No. He hasn't replied at all.

> If the patch is in -mm and it's not critical (like this subject),
> then it probably won't be merged until after 2.6.21 is released...

Fine by me, as long as it does get merged eventually so I can stop
watching for attempts to remove isdn4linux as obsolete.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigB6A0C849C4890BC4CF3CB99F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGJMMgMdB4Whm86/kRAhKMAJ9Vt2Z+TYZi3PGmVPzpKuvU102wFACeMnTF
8Zkz2h3ZLr4lJt6Ov1WQ+FY=
=PsfS
-----END PGP SIGNATURE-----

--------------enigB6A0C849C4890BC4CF3CB99F--
