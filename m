Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbZJMVz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbZJMVz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbZJMVz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:55:27 -0400
Received: from ozlabs.org ([203.10.76.45]:41336 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbZJMVzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:55:25 -0400
Subject: Re: [PATCH 2/8] bitmap: Introduce bitmap_set, bitmap_clear,
 bitmap_find_next_zero_area
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Fenghua Yu <fenghua.yu@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       x86@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-altix@sgi.com, Yevgeny Petrilin <yevgenyp@mellanox.co.il>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@redhat.com>,
       Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
       sparclinux@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-usb@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Lothar Wassmann <LW@KARO-electronics.de>
In-Reply-To: <20091013091017.GA18431@localhost.localdomain>
References: <1255076961-21325-1-git-send-email-akinobu.mita@gmail.com>
	 <1255076961-21325-2-git-send-email-akinobu.mita@gmail.com>
	 <20091009164100.85a36188.akpm@linux-foundation.org>
	 <20091013021818.GA3898@localhost.localdomain>
	 <20091013091017.GA18431@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qc5/2QIIQzGbB3R6aIJb"
Date: Wed, 14 Oct 2009 08:54:47 +1100
Message-Id: <1255470887.21871.2.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qc5/2QIIQzGbB3R6aIJb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-13 at 18:10 +0900, Akinobu Mita wrote:
> My user space testing exposed off-by-one error find_next_zero_area
> in iommu-helper.

Why not merge those tests into the kernel as a configurable boot-time
self-test?

cheers

--=-qc5/2QIIQzGbB3R6aIJb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrU9ycACgkQdSjSd0sB4dIXTACgpxW+LkFXep2w0my10iBFI6i2
V8MAoL7CL/p4hU/ZoKeP4Luo4ZBAcbef
=En+T
-----END PGP SIGNATURE-----

--=-qc5/2QIIQzGbB3R6aIJb--

