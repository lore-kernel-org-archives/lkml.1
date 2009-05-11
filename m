Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZEKSwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZEKSwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZEKSw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:52:28 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbZEKSw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:52:27 -0400
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
In-Reply-To: <alpine.LFD.2.01.0905111126320.3586@localhost.localdomain>
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>
	 <1241165805.13562.2.camel@johannes.local>
	 <f7848160905010619n74372488n45a7b7abccfe5ea7@mail.gmail.com>
	 <alpine.LFD.2.01.0905111046310.3586@localhost.localdomain>
	 <1242066170.3873.43.camel@johannes.local>
	 <alpine.LFD.2.01.0905111126320.3586@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uTlXJn0cIbf/ABcgmApl"
Date: Mon, 11 May 2009 20:52:19 +0200
Message-Id: <1242067939.3873.45.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uTlXJn0cIbf/ABcgmApl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-11 at 11:33 -0700, Linus Torvalds wrote:

> And the kernel I'm using is top-of-git, so that fix was there.

Ok.

> Which was obviously exactly why I was so unhappy about this, since the=20
> revert seemed to fix problems for me _despite_ the fix.

Curious really, since with that fix and a revert it would go to -1 dBm.
The only explanation I have is that then the Intel card defaults to some
safe value because it doesn't support values < 0.

johannes

--=-uTlXJn0cIbf/ABcgmApl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCHPaAAoJEODzc/N7+QmahPkP/jkchUF2XtDcbz0++enhnE37
pHIVHvRO872SgR0IohO+B8VJPnK8cd+S29fLmtzU82aUUvcvCKhg2dlzs3EBx5/N
zF833AaA7YJw1eMArlxdgbfw21KOnXf2sxBYy6bOb9fkM2cntBQ+JfnIP0il/pg9
OUd2ITIplaIQqCdIUBjh5VFMmwkS7y+XRdBVuJLg5y2bTJBS4x1PrPA6AhEACMRU
WoVML4S3pqITeUOGt3Hz5s5ohuxTJOOoKxi1jFouU+UBIXdOwWAH1Wl6seRco3vp
CRFfyWSuaJwHGCb7r+3SsZaUTPA0YjWgzV0YXqv1H3e4jBAqwWAzwn6sMjaPTRkP
AHBWKIYxSGqk4YecmDTzoD+E4FCRe/XagCNBmuXpr4eYV5LEsoaLON3Mje6NgsAH
HOjhwnlMVUAMauGglHAPQKid8Ri35XgLtWmls1QeKBbVxG5kNGPDszaFX3eqmgAP
DAxDVrlBIFII860pGD2jb2+Oxt0vCYGvvyCjUcJ4DOY7s4VvYTcqJiek2kSzN/5v
6v+2ul2GlIzTHWwBnE6S4VlKLwhcxi/3jURsU1wfLW4apHvDzDWLZuY2EbA0TxLL
QK1Yt/VJnUH2MOGTxKDICiMrCdfeI0AvMSrskhftAQVN5i60EBJgxSGATd7zGpGD
jcmHUfONzvVFdYMkp/il
=Pswu
-----END PGP SIGNATURE-----

--=-uTlXJn0cIbf/ABcgmApl--

