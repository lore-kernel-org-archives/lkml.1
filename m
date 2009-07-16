Return-Path: <linux-kernel-owner+w=401wt.eu-S933400AbZGPVVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbZGPVVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 17:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933392AbZGPVVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 17:21:42 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42580 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389AbZGPVVm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 17:21:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc1-mmotm0702 - ps command hangs inside kernel
In-Reply-To: Your message of "Thu, 16 Jul 2009 13:44:01 PDT."
             <20090716134401.0b1bec77.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <47423.1247518491@turing-police.cc.vt.edu> <20090713143810.5e17bbdb.akpm@linux-foundation.org> <1247549479.30711.8.camel@wall-e> <46776.1247771564@turing-police.cc.vt.edu> <1247775887.10888.17.camel@wall-e>
            <20090716134401.0b1bec77.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1247779284_4382P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Jul 2009 17:21:24 -0400
Message-ID: <52934.1247779284@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1247779284_4382P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Jul 2009 13:44:01 PDT, Andrew Morton said:
> On Thu, 16 Jul 2009 22:24:47 +0200
> Stefani Seibold <stefani@seibold.net> wrote:

> > The stack trace looks like you there is a old version included in the
> > 2.6.31-rc1-mmotm0702 patches.

> It would have been version 08.  I've now updated to v11.

Did -11 make it into the mmotm0715 tarball?  If so, I'll go build that and
if the problem doesn't re-manifest in a week or so we can call it fixed.


--==_Exmh_1247779284_4382P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKX5nUcC3lWbTT17ARAnLqAKCb0KV5gESbUyUuF54w4Jryw+K5WgCgyIsq
BEaGyr+PQ8NMu22fbUqH2a8=
=Lzn/
-----END PGP SIGNATURE-----

--==_Exmh_1247779284_4382P--
