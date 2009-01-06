Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbZAFF1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbZAFF1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 00:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbZAFF1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 00:27:38 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40725 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbZAFF1h (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 00:27:37 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
In-Reply-To: Your message of "Mon, 05 Jan 2009 18:00:33 +0900."
             <20090105175433.D875.KOSAKI.MOTOHIRO@jp.fujitsu.com>
From: Valdis.Kletnieks@vt.edu
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
            <20090105175433.D875.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231219651_3003P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Jan 2009 00:27:31 -0500
Message-ID: <3584.1231219651@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231219651_3003P
Content-Type: text/plain; charset=us-ascii

On Mon, 05 Jan 2009 18:00:33 +0900, KOSAKI Motohiro said:
> > #
> > page_fault-retry-with-nopage_retry.patch
> > page_fault-retry-with-nopage_retry-fix.patch
> > page_fault-retry-with-nopage_retry-fix-fix.patch
> 
> I oppose this.
> 
> Valdis.Kletnieks@vt.edu reported this patch has bug in
> "28-rc9-mmotm1219 page_fault-retry-with-nopage_retry.patch hoses xmms"
> thread.
> 
> Nobody answer his question yet.

It's still present in -mmotm0105.  I'm open to suggestions and any
debugging/instrumentation patches you might suggest - I'm completely at a
loss as to how the patch manages to mess up xmms the way it does.

--==_Exmh_1231219651_3003P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJYuvDcC3lWbTT17ARAqogAKDjUZ9I6G0rbUDt0vOkzmgItgov/wCglLpV
I2zZdIF3b/boU5DASko6KT0=
=ewAU
-----END PGP SIGNATURE-----

--==_Exmh_1231219651_3003P--
