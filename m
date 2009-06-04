Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZFDQpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZFDQpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbZFDQpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:45:24 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:54735 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbZFDQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:45:23 -0400
Subject: [GIT PULL] drm-intel fixes for 2.6.30-rc8
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7u8enoeIUEA4qeyuSRcU"
Date: Thu, 04 Jun 2009 16:45:16 +0000
Message-Id: <1244133916.11142.14.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7u8enoeIUEA4qeyuSRcU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The following changes since commit 9fa7eb283c5cdc2b0f4a8cfe6387ed82e5e9a3d3=
:
  Linus Torvalds (1):
        Linux 2.6.30-rc8

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

This fixes a bogus BUG_ON that I saw get triggered with the new texture
tiling code on gen4.  There are a couple of lovely further bugfixes in
drm-intel-next, but it's rc8 and I'd rather help quiet things down
so .30 gets out the door :)

Eric Anholt (1):
      drm/i915: Remove a bad BUG_ON in the fence management code.

 drivers/gpu/drm/i915/i915_gem.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-7u8enoeIUEA4qeyuSRcU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkon+hkACgkQHUdvYGzw6vf97wCbBaJXZhIjVUkzKuTKgYHzRY6X
AVAAnj985Ro9KdDRlGgswuXdfGvYmJ7X
=eBHM
-----END PGP SIGNATURE-----

--=-7u8enoeIUEA4qeyuSRcU--

