Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZEEO1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZEEO1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZEEO1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:27:39 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:56244 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbZEEO1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:27:38 -0400
Message-ID: <4A004CD3.5050104@novell.com>
Date: Tue, 05 May 2009 10:27:31 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v4 0/2] irqfd
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <alpine.DEB.1.10.0905050713160.25206@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0905050713160.25206@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4BBFFECBC663D92123965CDF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4BBFFECBC663D92123965CDF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Mon, 4 May 2009, Gregory Haskins wrote:
>
>  =20
>> (Applies to kvm.git:7da2e3ba, plus you will also need Davide Libenzi's=

>> eventfd_file_create() patch, which you can find here:
>>
>> http://www.mail-archive.com/kvm@vger.kernel.org/msg13923.html
>>    =20
>
> Ping me back if Al acks the irqfd thing, that I'll take a better look a=
t=20
> the patch above and make an official post. Without any users, I'd rathe=
r=20
> leave the current code as is.
>  =20

Will do, Davide.  Thank you.

-Greg



--------------enig4BBFFECBC663D92123965CDF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoATNMACgkQlOSOBdgZUxltPACgj4Fr4O5exptSaeREMNmnVor5
O8sAn1DgXcUIxR9/BxHDWOHE90cq2u/X
=08fX
-----END PGP SIGNATURE-----

--------------enig4BBFFECBC663D92123965CDF--
