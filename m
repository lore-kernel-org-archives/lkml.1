Return-Path: <linux-kernel-owner+w=401wt.eu-S1759978AbZDOMp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978AbZDOMp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZDOMpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:45:18 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:4036 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZDOMpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:45:17 -0400
Message-ID: <49E5D6D9.3040903@imap.cc>
Date: Wed, 15 Apr 2009 14:45:13 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fast testing
References: <49E5D0C1.6010608@wpkg.org>
In-Reply-To: <49E5D0C1.6010608@wpkg.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC2993D8500C83649ED964CC9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC2993D8500C83649ED964CC9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Tomasz Chmielewski schrieb:
>> Wow. Nice machine. I wish I had one like that. And how long until
>> the GUI is usable again and you can actually continue working?
>>=20
>> For comparison: my 3.4 GHz Pentium D takes 30 secs for kernel start
>> (ie. until it begins looking for the filesystems),
>=20
> Including all BIOS routines?

No - from hitting Enter in the GRUB menu.

>>  2 mins until the graphical login screen appears, and
>> 5 mins from logging in to the GUI being completely present.
>=20
> I have an old 366 MHz / 192 MB machine which boots to GUI much faster.

Might depend on the value of "GUI". Mine wouldn't even load in 192 MB.
Anyway, my preceding P3/700 MHz/512 MB box hasn't been much worse,
either.

> Something's wrong with your setup (unless you start really lots of=20
> things or have some other, "uncommon" things).

Hmm, it's always been like that. As for "uncommon", this is a more
or less out of the box openSUSE 10.3 installation. (Without Beagle,
in case you were wondering.) Perhaps that's what's wrong? :-)

OTOH, even the GUIless CentOS server boxes I look after for a
living take about 5 mins until they are up and running again after
a kernel update - including BIOS, but without the fsck penalty.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enigC2993D8500C83649ED964CC9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJ5dbaQ3+did9BuFsRAsWDAJ4ksXuRhTCt43uBYWIQq56ox9yfTACfYGe+
6enAtWBeMZa9D2gP7xJfLhA=
=YJyO
-----END PGP SIGNATURE-----

--------------enigC2993D8500C83649ED964CC9--
