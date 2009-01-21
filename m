Return-Path: <linux-kernel-owner+w=401wt.eu-S1763345AbZAUOyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763345AbZAUOyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbZAUOyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:54:08 -0500
Received: from mail.phnxsoft.com ([195.227.45.4]:3175 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbZAUOyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:54:07 -0500
X-Greylist: delayed 1928 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2009 09:54:07 EST
Message-ID: <49772F79.8060009@imap.cc>
Date: Wed, 21 Jan 2009 15:21:45 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.18) Gecko/20081031 SeaMonkey/1.1.13 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] x86: Merge hardirq.h
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232457345-12366-5-git-send-email-brgerst@gmail.com> <4976DA9C.7000500@kernel.org> <20090121101307.GD18728@elte.hu> <49770808.2030909@kernel.org>
In-Reply-To: <49770808.2030909@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE9C94EC3064C7D4C66736E8A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE9C94EC3064C7D4C66736E8A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Tejun Heo schrieb:
> [...] but when the patch is touching this low in arch
> code, I don't think small four configuration build isn't too much
> before sending out a patchset.  With two quad core machines and ram
> disk configured, it just doesn't take that much of time (which BTW
> doesn't cost that much these days).  With my typical test config,
> whole build takes about 80 to 90 seconds.  Four times that is still
> under ten minutes.

Wow. Do want. :-)

SCNR
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigE9C94EC3064C7D4C66736E8A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJdy+CQ3+did9BuFsRAuI7AJwI7zzl8RfbEr7fVVo1JxtLITA7tgCdGkNW
Boj4QAzpz0n09XayNEdfkBc=
=7NdP
-----END PGP SIGNATURE-----

--------------enigE9C94EC3064C7D4C66736E8A--
