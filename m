Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYB1GkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYB1GkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYB1GkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:40:03 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38971 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYB1GkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:40:01 -0500
Date: Thu, 28 Feb 2008 17:39:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 28
Message-Id: <20080228173955.8dad1d5e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Feb_2008_17_39_55_+1100_bdIFM04FnIkkL3ui"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Feb_2008_17_39_55_+1100_bdIFM04FnIkkL3ui
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Resend due to cut and paste error on address :-(]

Hi all,

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
allmodconfig for both powerpc and x86_64.

There was only one minor merge problem.

We are up to 38 trees, more are welcome (even if they are currently
empty).

Status of my local build tests is at
http://kisskb.ellerman.id.au/kisskb/branch/9/.  We have added a 64bit
s390 compiler to our list.  If maintainers want to give advise about
cross compilers/configs that work, we are always open to add more builds.

Also, the linux-next tree is being build/boot tested by the guys at
test.kernel.org.  Thanks to them.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__28_Feb_2008_17_39_55_+1100_bdIFM04FnIkkL3ui
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHxldCTgG2atn1QN8RAoCJAJsFQsyzBF4pZWi1+yYZ7/wni4qcggCfaMIQ
T00hNLuEY6B47Kp6VGn2sSA=
=5qUu
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Feb_2008_17_39_55_+1100_bdIFM04FnIkkL3ui--
