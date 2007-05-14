Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbXENXoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbXENXoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 19:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbXENXop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 19:44:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47625 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbXENXon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 19:44:43 -0400
Date: Tue, 15 May 2007 09:44:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
       cmm@us.ibm.com
Subject: Re: [PATCH 1/5][TAKE2] fallocate() implementation on i86, x86_64
 and powerpc
Message-Id: <20070515094436.d441098f.sfr@canb.auug.org.au>
In-Reply-To: <20070514144524.GA31748@amitarora.in.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071417.GI355@devserv.devel.redhat.com>
	<20070417125514.GA7574@amitarora.in.ibm.com>
	<20070418130600.GW5967@schatzie.adilger.int>
	<20070420135146.GA21352@amitarora.in.ibm.com>
	<20070420145918.GY355@devserv.devel.redhat.com>
	<20070424121632.GA10136@amitarora.in.ibm.com>
	<20070426175056.GA25321@amitarora.in.ibm.com>
	<20070514132926.GA30768@amitarora.in.ibm.com>
	<20070514142820.GA31468@amitarora.in.ibm.com>
	<20070514144524.GA31748@amitarora.in.ibm.com>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_May_2007_09_44_36_+1000_FmQQEkgMAA8ZAwtk"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_May_2007_09_44_36_+1000_FmQQEkgMAA8ZAwtk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Mon, 14 May 2007 20:15:24 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
>
> This patch implements sys_fallocate() and adds support on i386, x86_64
> and powerpc platforms.

This patch no longer applies to Linus' tree - for a start there is no file
arch/x86_64/kernel/functionlist any more.

Can you rebase it, please?

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_May_2007_09_44_36_+1000_FmQQEkgMAA8ZAwtk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGSPRpFdBgD/zoJvwRAuHCAJsEB8TyYfKxqEtWnHM7smTPNqRiPwCfYj2B
kUd5qmBLOd+TYg003bKAuVw=
=ap96
-----END PGP SIGNATURE-----

--Signature=_Tue__15_May_2007_09_44_36_+1000_FmQQEkgMAA8ZAwtk--
