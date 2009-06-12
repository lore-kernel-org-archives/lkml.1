Return-Path: <linux-kernel-owner+w=401wt.eu-S932264AbZFLC54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbZFLC54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 22:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932143AbZFLC5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 22:57:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46525 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085AbZFLC5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 22:57:50 -0400
Date: Fri, 12 Jun 2009 12:57:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the kvm tree
Message-Id: <20090612125745.afadf2aa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Jun_2009_12_57_45_+1000_n08M6kVILlhX_Hnm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jun_2009_12_57_45_+1000_n08M6kVILlhX_Hnm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Avi,

Today's linux-next merge of the kvm tree got conflicts in about 23
files.  This has happened because only a subset of the kvm tree that is
merged into the linux-next tree has been merged into Linus' tree *and*
that subset was rebased before the merge happened.

I have dropped the kvm tree.

Is there some other branch that I should be including in linux-next
instead of the current one i.e. something that represents what you will
actually send to Linus that doesn't need to be rebased before that
happens?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Jun_2009_12_57_45_+1000_n08M6kVILlhX_Hnm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoxxCkACgkQjjKRsyhoI8xy3gCgrOhHNTRlTT8+lKVtGViwOPSw
kkEAoI0PAIhlng/OktB9X2fZZzxXkTIF
=6ZPq
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jun_2009_12_57_45_+1000_n08M6kVILlhX_Hnm--
