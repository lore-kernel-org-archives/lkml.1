Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbZKJXKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbZKJXKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 18:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758648AbZKJXKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 18:10:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46189 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758606AbZKJXKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 18:10:13 -0500
Date: Wed, 11 Nov 2009 10:10:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: md tree fetch error
Message-Id: <20091111101015.9104301e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Nov_2009_10_10_15_+1100_vgEOXppPObtYRMs7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Nov_2009_10_10_15_+1100_vgEOXppPObtYRMs7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

Today's linux-next fetch of the md tree produced this error:

neil.brown.name[0: 220.233.11.133]: errno=3DConnection timed out
fatal: unable to connect a socket (Connection timed out)

I will use the version of the md tree from next-20091110.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_Nov_2009_10_10_15_+1100_vgEOXppPObtYRMs7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr58tcACgkQjjKRsyhoI8wSdACZAXgP/lhclAJKC1fxInfc5dW7
iQoAoIKOLw/dVs2Dtc2hnb6RjCjF4Z61
=FjFX
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Nov_2009_10_10_15_+1100_vgEOXppPObtYRMs7--
