Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbZEGUea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbZEGUea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZEGUeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:34:17 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:37776 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZEGUeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:34:16 -0400
Message-ID: <4A0345BF.6070902@novell.com>
Date: Thu, 07 May 2009 16:34:07 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Gregory Haskins <gregory.haskins@gmail.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <4A032771.6050703@redhat.com> <4A032A74.2020809@novell.com> <4A032FDD.8020209@redhat.com> <20090507190751.GE3036@sequoia.sous-sol.org> <4A033281.8050002@novell.com> <20090507192145.GF3036@sequoia.sous-sol.org> <4A033685.7070802@gmail.com> <20090507202506.GG3036@sequoia.sous-sol.org>
In-Reply-To: <20090507202506.GG3036@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA56EEE44F210AFD0F075D711"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA56EEE44F210AFD0F075D711
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Chris Wright wrote:
> * Gregory Haskins (gregory.haskins@gmail.com) wrote:
>  =20
>> What I am not clear on is how you would know to flag the address to
>> begin with.
>>    =20
>
> That's why I mentioned pv_io_ops->iomap() earlier.  Something I'd expec=
t
> would get called on IORESOURCE_PVIO type.

Yeah, this wasn't clear at the time, but I totally get what you meant
now in retrospect.

-Greg




--------------enigA56EEE44F210AFD0F075D711
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoDRb8ACgkQlOSOBdgZUxnL+wCfbnTGCcwplOv9DlB2pzDqvBzu
TiAAnAkrnfs13QA7lsF5VaJhNGFpOF1j
=6mP3
-----END PGP SIGNATURE-----

--------------enigA56EEE44F210AFD0F075D711--
