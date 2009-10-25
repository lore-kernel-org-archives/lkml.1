Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZJYXES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZJYXES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 19:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZJYXER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 19:04:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52713 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbZJYXER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 19:04:17 -0400
Date: Mon, 26 Oct 2009 10:04:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next:  device-mapper quilt series import failure
Message-Id: <20091026100420.41cf9a22.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__26_Oct_2009_10_04_20_+1100_Agrtp+9bPH7U49AY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Oct_2009_10_04_20_+1100_Agrtp+9bPH7U49AY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

Today's linux-next import of the device-mapper quilt series failed like
this:

dm-snapshot-abstract-minimum_chunk_size-fn.patch
error: patch failed: drivers/md/dm-snap.c:1400
error: drivers/md/dm-snap.c: patch does not apply

I will use the device-mapper tree from next-20091016 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__26_Oct_2009_10_04_20_+1100_Agrtp+9bPH7U49AY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrk2XQACgkQjjKRsyhoI8xBhgCfS5ckNoseMibEpgX/+pC2G5bO
HGMAoJdL+kAWH5K2qNUQ53PFdxr5CiTo
=geNX
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Oct_2009_10_04_20_+1100_Agrtp+9bPH7U49AY--
