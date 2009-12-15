Return-Path: <linux-kernel-owner+w=401wt.eu-S1761035AbZLOT7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761035AbZLOT7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760997AbZLOT7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:59:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759861AbZLOT7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:59:46 -0500
Date: Tue, 15 Dec 2009 13:59:36 -0600
From: Clark Williams <williams@redhat.com>
To: RT <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Carsten Emde <ce@ceag.ch>,
       John Kacur <jkacur@redhat.com>
Subject: v0.57 of rt-tests available
Message-ID: <20091215135936.5a7f2d56@torg>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ha20NZVN/JW.5=lOkGh/Z/d"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ha20NZVN/JW.5=lOkGh/Z/d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Version 0.57 of the rt-tests package is now available both as a tarball
on kernel.org and in my git repository:

tarball:

http://www.kernel.org/pub/linux//kernel/people/clrkwllms/rt-tests/rt-tests-=
0.57.tar.bz2

git:
	git://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-tests.git

This version adds tests from Carsten Emde:

- backfire/sendme - measure signal propagation time from driver to
  userspace
- ptsematest - measure latency of posix mutex
- sigwaittest - measure interthread signal latency
- svsematest - measure interthread SystemV semaphore latency

Many thanks to John Kacur <jkacur@redhat.com> for doing the integration
work in adding these tests.=20

Clark

--Sig_/Ha20NZVN/JW.5=lOkGh/Z/d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAksn6q4ACgkQHyuj/+TTEp2kRgCgs2YZlbGA+sWCUdRL/JSLJnH8
LZwAoLJX7VfE3XxS0n1OxswOSyy8E/zj
=S3gB
-----END PGP SIGNATURE-----

--Sig_/Ha20NZVN/JW.5=lOkGh/Z/d--
