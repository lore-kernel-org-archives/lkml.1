Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbZAEWfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbZAEWfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZAEWfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:35:38 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53208 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZAEWfh (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:35:37 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Ying Han <yinghan@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: 2.6.29 -mm merge plans
In-Reply-To: Your message of "Mon, 05 Jan 2009 01:07:26 PST."
             <20090105010726.c0433fea.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090105175433.D875.KOSAKI.MOTOHIRO@jp.fujitsu.com>
            <20090105010726.c0433fea.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231194895_3204P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Jan 2009 17:34:55 -0500
Message-ID: <6991.1231194895@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231194895_3204P
Content-Type: text/plain; charset=us-ascii

On Mon, 05 Jan 2009 01:07:26 PST, Andrew Morton said:
> (cc's added)
> 
> On Mon,  5 Jan 2009 18:00:33 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.
fujitsu.com> wrote:
> 
> > > #
> > > page_fault-retry-with-nopage_retry.patch
> > > page_fault-retry-with-nopage_retry-fix.patch
> > > page_fault-retry-with-nopage_retry-fix-fix.patch
> > 
> > I oppose this.
> > 
> > Valdis.Kletnieks@vt.edu reported this patch has bug in
> > "28-rc9-mmotm1219 page_fault-retry-with-nopage_retry.patch hoses xmms"
> > thread.
> > 
> > Nobody answer his question yet.
> 
> OK, thanks.  I actually thought we'd fixed that?

I'll check mmotm-0105 later tonight, I was still seeing the issue in -1230.

--==_Exmh_1231194895_3204P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJYosPcC3lWbTT17ARAm7XAKCr0CnmwiEt//hDB/7CAAzQtwDWowCgjnXm
2NxqGFvA5upZsQv9qBa3A6M=
=SRvG
-----END PGP SIGNATURE-----

--==_Exmh_1231194895_3204P--
