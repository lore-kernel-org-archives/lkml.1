Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbYB2FhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbYB2FhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 00:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYB2Fgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 00:36:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54317 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbYB2Fgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 00:36:51 -0500
Date: Fri, 29 Feb 2008 16:36:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 29
Message-Id: <20080229163648.7b758e28.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Feb_2008_16_36_48_+1100_Bn8JNqio+BGu.C=S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Feb_2008_16_36_48_+1100_Bn8JNqio+BGu.C=S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
allmodconfig for both powerpc and x86_64.

There were only two merge problems - notifications have been sent.

We are up to 39 trees, more are welcome (even if they are currently
empty).

Status of my local build tests is at
http://kisskb.ellerman.id.au/kisskb/branch/9/.  If maintainers want to
give advice about cross compilers/configs that work, we are always open
to add more builds.

Also, the linux-next tree is being build/boot tested by the guys at
test.kernel.org.  Thanks to them.

This tree include Willy's semaphore updates.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__29_Feb_2008_16_36_48_+1100_Bn8JNqio+BGu.C=S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHx5n1TgG2atn1QN8RApMPAJ9huAkhrUfDMEYL0uJvUZKhtXliFwCdEXkZ
vHLaTrKaHHXprVdO0QGf/PA=
=jIzf
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Feb_2008_16_36_48_+1100_Bn8JNqio+BGu.C=S--
