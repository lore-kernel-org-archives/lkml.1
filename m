Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbZDBMus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbZDBMus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZDBMuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:50:35 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34312 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZDBMue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:50:34 -0400
Message-ID: <49D4B523.9020802@novell.com>
Date: Thu, 02 Apr 2009 08:52:51 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Avi Kivity <avi@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402085253.GA29932@gondor.apana.org.au> <49D487A6.407@redhat.com> <49D49C1F.6030306@novell.com> <200904022243.21088.rusty@rustcorp.com.au> <49D4B4A3.5070008@novell.com>
In-Reply-To: <49D4B4A3.5070008@novell.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig43FAAC99DF00DB24922CEDCE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig43FAAC99DF00DB24922CEDCE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Rusty Russell wrote:
>  =20
>
>>  there will *never* be another packet in the queue
>> at this point, since it wasn't running.
>>  =20
>>    =20
> Yep, and I'll be the first to admit that my design only looks forward. =

>  =20
To clarify, I am referring to the internal design of the venet-tap
only.  The general vbus architecture makes no such policy decisions.

-Greg


--------------enig43FAAC99DF00DB24922CEDCE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknUtSMACgkQlOSOBdgZUxkOjwCfZal+bMV47PK5hMMJosKdkkYo
wA0AnAm/K+VL6QhsIbYV9oqsMfRXWqxD
=YN4A
-----END PGP SIGNATURE-----

--------------enig43FAAC99DF00DB24922CEDCE--
