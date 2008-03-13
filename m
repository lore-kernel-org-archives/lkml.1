Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbYCMGgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbYCMGgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYCMGgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:36:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38960 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbYCMGge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:36:34 -0400
Date: Thu, 13 Mar 2008 17:35:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 13
Message-Id: <20080313173506.2613be02.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Mar_2008_17_35_06_+1100_7CcEKMnGBGew/pfE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Mar_2008_17_35_06_+1100_7CcEKMnGBGew/pfE
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

We are up to 47 trees, more are welcome (even if they are currently
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

--Signature=_Thu__13_Mar_2008_17_35_06_+1100_7CcEKMnGBGew/pfE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH2MsfTgG2atn1QN8RAp0KAJ9EsVgzgum1jGlTk+A8cmuRW+p6kQCdFJTw
DP6OSZk9poOU/uhC0Uj6fBA=
=fjjU
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Mar_2008_17_35_06_+1100_7CcEKMnGBGew/pfE--
