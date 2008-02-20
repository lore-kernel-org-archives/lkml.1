Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbYBTSX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbYBTSX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbYBTSXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:23:48 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41815 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbYBTSXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:23:46 -0500
X-Sasl-enc: 2UAC03bf4kONV7xWRmxJjfgVDS+yVB7ACiDrD/tKiPkI 1203531825
Message-ID: <47BC7024.3010201@imap.cc>
Date: Wed, 20 Feb 2008 19:23:32 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Gregory Nietsky <gregory@networksentry.co.za>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN?
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc> <47BC5B5B.90308@firstfloor.org>
In-Reply-To: <47BC5B5B.90308@firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCFED035F9B68313A23CB5B00"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCFED035F9B68313A23CB5B00
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 20.02.2008 17:54 schrieb Andi Kleen:
>> mISDN has two problems, which are of course interrelated:
>>
>> a) complete lack of documentation for the in-kernel driver interface
>>    (equivalent of Documentation/isdn/INTERFACE)
>=20
> Most subsystems in the kernel would disqualify under that rule

I beg to differ. Most subsystems do have at least rudimentary
documentation. (I'm spoiled by the USB subsystem, of course. :-)

> Did you ever look for full documentation on how to write Ethernet
> drivers for example? Some bits are documented, but far from all

I am not asking for "full documentation". "Some bits" would amply
suffice. Documentation/isdn/INTERFACE, the interface description
for the "old" isdn4linux subsystem, is far from complete, either.
But it contains enough hints so that I knew where to start.

>> (maintainer of an isdn4linux driver, waiting desperately for
>> documentation on how to convert to the new CAPI/mISDN world
>> but tired of asking for it in vain)
>=20
> My advice is that you just read the source of some existing drivers
> for examples and copy them and of the subsystem itself if anything is
> unclear. That is how Linux drivers are usually written.

Usually, yes. But I find it unusually hard in this particular case.
In fact I have been trying to do that for two years now, without
getting anywhere. Reading code without a hint of what the authors
are trying to do is terribly time-consuming, to put it mildly.

Thanks,
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigCFED035F9B68313A23CB5B00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHvHAuMdB4Whm86/kRAi4JAJwN26fTWfiHP2u+Y6E6oyzLxKbV4QCeNjjP
vwViFA/S95uqO61ujRJ6WaE=
=Sb06
-----END PGP SIGNATURE-----

--------------enigCFED035F9B68313A23CB5B00--
