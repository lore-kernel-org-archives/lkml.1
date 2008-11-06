Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYKFFgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYKFFgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 00:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYKFFgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 00:36:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37547 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYKFFgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 00:36:44 -0500
Date: Thu, 6 Nov 2008 16:36:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>, <sparclinux@vger.kernel.org>
Subject: sparc/staging compile error
Message-Id: <20081106163626.2306ad75.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__6_Nov_2008_16_36_26_+1100_2zsy5uoX1u7LpmYt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Nov_2008_16_36_26_+1100_2zsy5uoX1u7LpmYt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's tree from Linus gets the following error from a sparc
allmodconfig build:

ERROR: "___f_flush_cache_range" [drivers/staging/poch/poch.ko] undefined!

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Nov_2008_16_36_26_+1100_2zsy5uoX1u7LpmYt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkSgloACgkQjjKRsyhoI8zIfwCgmJGxkMljrEV+GcCuSvYw1g42
6PYAn02mQtb8kVGDbDs3NqP8El/bpIsK
=xeay
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Nov_2008_16_36_26_+1100_2zsy5uoX1u7LpmYt--
