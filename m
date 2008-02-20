Return-Path: <linux-kernel-owner+w=401wt.eu-S1763299AbYBTFf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763299AbYBTFf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYBTFfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:35:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58623 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbYBTFfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:35:12 -0500
Date: Wed, 20 Feb 2008 16:34:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: linux-next: Tree for Feb 20
Message-Id: <20080220163457.79b9189f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Feb_2008_16_34_57_+1100_VEoZJ0+b=I_O/pXe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Feb_2008_16_34_57_+1100_VEoZJ0+b=I_O/pXe
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

There were no merge conflicts and only one build failure!

We are up to 27 trees, more are welcome (even if they are currently
empty).  I would encourage architecture maintainers, in particular, to
set up a git branch or quilt tree now to avoid the rush after RC2 :-)

I will stop making these announcements now unless there is some change to
the tree or things people should know.  There should be a new tree every
(Australian Capital Territory) working day.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Feb_2008_16_34_57_+1100_VEoZJ0+b=I_O/pXe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHu7wOTgG2atn1QN8RAhjOAKCT+XgFeWki51GMgv5+lWRWsDSjogCggztX
yr7ieVg/fE16VBus4j7x5BM=
=kAW1
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Feb_2008_16_34_57_+1100_VEoZJ0+b=I_O/pXe--
