Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYCRJ4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYCRJ4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 05:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYCRJ42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 05:56:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48582 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbYCRJ41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 05:56:27 -0400
Date: Tue, 18 Mar 2008 20:52:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 18
Message-Id: <20080318205259.13726d23.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_Mar_2008_20_52_59_+1100_6eyVv1ylVY=zN6FC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Mar_2008_20_52_59_+1100_6eyVv1ylVY=zN6FC
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

There were a couple of merge conflicts (fairly trivial). (And the
expected build failure in st.c fixed by reverting the removal of struct
class_device.) Notification has been sent.

We are up to 48 trees, more are welcome (even if they are currently
empty).  The influx of new trees has been underwhelming.  Thanks to those
who have contributed, and to those who haven't, please do.

In particular, I have very few of the architecture trees ....

Status of my local build tests is at
http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__18_Mar_2008_20_52_59_+1100_6eyVv1ylVY=zN6FC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH35EATgG2atn1QN8RAkaJAJ9X81BMY40gb5hldXb0l4CvdJbnMQCgjmUp
Tmluug88HjywSuC+Pls+4qw=
=ufQh
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Mar_2008_20_52_59_+1100_6eyVv1ylVY=zN6FC--
