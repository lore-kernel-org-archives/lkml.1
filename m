Return-Path: <linux-kernel-owner+w=401wt.eu-S1760810AbXK1P52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbXK1P52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbXK1P5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:57:20 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:2479 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410AbXK1P5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:57:19 -0500
Message-ID: <474D8FD2.4010009@imap.cc>
Date: Wed, 28 Nov 2007 16:57:06 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Dave Quigley <dpquigl@tycho.nsa.gov>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: git guidance
References: <474C9B31.8000408@imap.cc>	 <Pine.LNX.4.64.0711280019200.4181@fbirervta.pbzchgretzou.qr> <1196262922.19921.20.camel@moss-terrapins.epoch.ncsc.mil>
In-Reply-To: <1196262922.19921.20.camel@moss-terrapins.epoch.ncsc.mil>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD9593CDFC690E82B2CB89CCA"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD9593CDFC690E82B2CB89CCA
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Dave Quigley schrieb:
> There is a project listed on the kernel.org git page called guilt. I
> find it very useful. It is much more responsive than stgit and it
> actually has a git backend which quilt does not.
>=20
> On Wed, 2007-11-28 at 00:20 +0100, Jan Engelhardt wrote:
>> On Nov 27 2007 23:33, Tilman Schmidt wrote:
>> >
>> >Well, it did. So now I'm back to keeping a virgin kernel source tree
>> >alongside my development area in order to produce diffs. That can't
>> >be right?
>> >
>> No, it can't. Use stgit/quilt ;p

In which respect would stgit/quilt/guilt help me? At first glance
they just seem to add another level of complexity.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Yes, I have searched Google!


--------------enigD9593CDFC690E82B2CB89CCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHTY/YQ3+did9BuFsRAq3WAKCHZ8RuB93Nnc8Mez/060YyK2zkCQCfcxcC
NqiKG9jUpQykPlXo3bOMmDU=
=AHNa
-----END PGP SIGNATURE-----

--------------enigD9593CDFC690E82B2CB89CCA--
