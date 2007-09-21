Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbXIURSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbXIURSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbXIURSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:18:14 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40213 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbXIURSN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:18:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>, Dave Airlie <airlied@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
In-Reply-To: Your message of "Fri, 21 Sep 2007 01:44:41 +0200."
             <20070920234441.GK18707@one.firstfloor.org>
From: Valdis.Kletnieks@vt.edu
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com> <20070920220604.GA17536@waste.org> <20070920230304.GJ18707@one.firstfloor.org> <20070920233114.GR4219@waste.org>
            <20070920234441.GK18707@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190395082_2847P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Sep 2007 13:18:02 -0400
Message-ID: <10319.1190395082@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190395082_2847P
Content-Type: text/plain; charset=us-ascii

On Fri, 21 Sep 2007 01:44:41 +0200, Andi Kleen said:

> Full bisect needed then I guess. Ok as a short cut you could perhaps
> the cpa-* patches first (might need to drop some later depending 
> patches), then the drm and agp trees.

The later depending patches:

x86_64-mm-cpa-clflush.patch
x86_64-mm-cpa-cleanup.patch
x86_64-mm-cpa-einval.patch
x86_64-mm-cpa-arch-macro.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch



--==_Exmh_1190395082_2847P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG8/zKcC3lWbTT17ARAojGAJ9h2KxRtYhqySk0nesYvs/Ioey40wCgy/GH
ZBfdNjQX3WP9KwdFQWAyP8w=
=u/xD
-----END PGP SIGNATURE-----

--==_Exmh_1190395082_2847P--
