Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbYCLFtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbYCLFtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 01:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYCLFtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 01:49:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55190 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbYCLFtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 01:49:04 -0400
Date: Wed, 12 Mar 2008 16:47:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 12
Message-Id: <20080312164755.08123176.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Mar_2008_16_47_55_+1100_xF5H4IWHtu/7Fr8A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Mar_2008_16_47_55_+1100_xF5H4IWHtu/7Fr8A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(tar balls at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
allmodconfig for both powerpc and x86_64.

There were a few merge conflicts (trivial) and two build breakages (both
in hand).

We are up to 45 trees, more are welcome (even if they are currently
empty).  The influx of new trees has been underwhelming.  Thanks to those
who have contributed, and to those who haven't, please do.

In particular, I have very few of the architecture trees ....

Status of my local build tests is at
http://kisskb.ellerman.id.au/kisskb/branch/9/.  If maintainers want to
give advice about cross compilers/configs that work, we are always open
to add more builds.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Mar_2008_16_47_55_+1100_xF5H4IWHtu/7Fr8A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH126PTgG2atn1QN8RArStAJ911M1u80tKPRUpmO2zfAEOCxs8ggCdG6Nc
QAVsnfBypeBpRrXx2ppANtQ=
=ooe8
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Mar_2008_16_47_55_+1100_xF5H4IWHtu/7Fr8A--
