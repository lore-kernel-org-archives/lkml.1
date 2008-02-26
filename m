Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbYBZGGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbYBZGGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 01:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYBZGGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 01:06:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:32810 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbYBZGGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 01:06:39 -0500
Date: Tue, 26 Feb 2008 17:06:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 26
Message-Id: <20080226170633.120dd764.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_Feb_2008_17_06_33_+1100_ozm_qjN+wk4Mwt21"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Feb_2008_17_06_33_+1100_ozm_qjN+wk4Mwt21
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

There were only two minor merge problems.

We are up to 34 trees, more are welcome (even if they are currently
empty).

Status of my local build tests is at
http://kisskb.ellerman.id.au/kisskb/branch/9/. We have added arm and m68k
to the architectures built.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Feb_2008_17_06_33_+1100_ozm_qjN+wk4Mwt21
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHw6xuTgG2atn1QN8RAkTtAJ9M10CsLfias1AQu7Iu8cPApxUJbQCfQCfY
BTbgJR1eSlC/R5sP+ui+nic=
=ZSqH
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Feb_2008_17_06_33_+1100_ozm_qjN+wk4Mwt21--
