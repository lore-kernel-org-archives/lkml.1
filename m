Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbZGPSyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbZGPSyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 14:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932951AbZGPSyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 14:54:08 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44406 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940AbZGPSyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 14:54:06 -0400
Message-ID: <4A5F773C.2020303@novell.com>
Date: Thu, 16 Jul 2009 14:53:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       glommer@redhat.com, aliguori@us.ibm.com
Subject: Re: [KVM PATCH] KVM: introduce "xinterface" API for external interaction
 with guests
References: <20090716150323.29318.17714.stgit@dev.haskins.net> <20090716151945.29318.10882.stgit@dev.haskins.net> <200907161852.42071.arnd@arndb.de> <4A5F6FF4.2090706@novell.com>
In-Reply-To: <4A5F6FF4.2090706@novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF502AA5E77830938571E49EC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF502AA5E77830938571E49EC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Note that if we are going to generalize the interface to support other
> guests as you may have been suggesting above, it should probably stay
> statically linked (and perhaps live in ./lib or something)
>  =20

More specifically, it can no longer live in kvm.ko.  I guess it
technically doesn't have to be statically linked, though (e.g.
xinterface.ko is fine, too).

Regards,
-Greg


--------------enigF502AA5E77830938571E49EC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpfdzwACgkQlOSOBdgZUxnggwCfYUXZbdkBEbmSM2ka4uFozmqy
IVIAnR5OLxafAerj8t/EP3juVtFPLB5l
=Bko2
-----END PGP SIGNATURE-----

--------------enigF502AA5E77830938571E49EC--
