Return-Path: <linux-kernel-owner+w=401wt.eu-S1765260AbXFHPqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765260AbXFHPqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762222AbXFHPpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:45:46 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33249 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758713AbXFHPpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:45:45 -0400
Date: Fri, 8 Jun 2007 08:45:24 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [patch 00/32] 2.6.20-stable review
Message-ID: <20070608154524.GR3723@sequoia.sous-sol.org>
References: <20070608071511.159309000@sous-sol.org> <F1D642E5A91BC94D9504EC83AE19E6B01289C1@ecqcmtlmail3.quebec.int.ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B01289C1@ecqcmtlmail3.quebec.int.ec.gc.ca>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Fortier,Vincent [Montreal] (Vincent.Fortier1@EC.GC.CA) wrote:
> I have encoutered a bug using fixdep when compiling the Apani VPN
> contivity client v3.3 (v3.5 seems fine).  The bug started happening with
> the release of the 2948 build of FC6 kernel (corresponding to a post
> 2.6.20.7) and caused fixdep to segfault.  This has been fixed in 2.6.21.
> I tried to trigger the bug using the 2.6.21 patch (thnx to the raw ouput
> option in git.kernel.org) and it really seems to resolve the problem.
> 
> The original commit:
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.20.y.git;a=commit;h=3dedd29b0ef5c7a36ac835ac5524a6a8e22c22ab
> 
> The fix:
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.21.y.git;a=commit;h=1ea6b2418cd2c6a6f31067ed6ece5cd12c69351e
> 
> Could it be included in this new stable release of 2.6.20 ?

That patch is actually in this review cycle.  If you want to grab the
roll-up patch and test, that would be great.

http://www.kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.20.14-rc1.{gz,bz2}

thanks,
-chris
