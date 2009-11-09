Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbZKIHP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbZKIHP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZKIHP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:15:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50775 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbZKIHP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:15:26 -0500
Date: Mon, 9 Nov 2009 18:15:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Patrick Johnson <teknotus@teknot.us>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: linux-next: manual merge of the staging tree with the pcmcia tree
Message-Id: <20091109181527.a42431bc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Nov_2009_18_15_27_+1100_0Y.RKbU71jaoI5sj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Nov_2009_18_15_27_+1100_0Y.RKbU71jaoI5sj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/comedi/drivers/ni_mio_cs.c between commit
4e338b7f55b4c30e60fa3fa9ff3d21e930f40116 ("pcmcia/staging: update comedi
drivers") from the pcmcia tree and commit
bd7881ee58045b4b684f4400b24081656e0c6986 ("Staging: comedi: ni_mio_cs.c:
coding style cleanup") from the staging tree.

I fixed it up (mainly using the pcmcia tree version when there was a
clash) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Signature=_Mon__9_Nov_2009_18_15_27_+1100_0Y.RKbU71jaoI5sj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr3wY8ACgkQjjKRsyhoI8wsNQCdFiPsERpnsGmycpmfxYsl06m2
HEkAn3gTkdJEYEgXRqyR1aSJTnjWgklC
=qaTi
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Nov_2009_18_15_27_+1100_0Y.RKbU71jaoI5sj--
