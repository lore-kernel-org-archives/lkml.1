Return-Path: <linux-kernel-owner+w=401wt.eu-S1761263AbXEOBoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263AbXEOBoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 21:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758985AbXEOBnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 21:43:55 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4268 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758906AbXEOBnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 21:43:55 -0400
Date: Tue, 15 May 2007 11:43:44 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot - crypto?
Message-ID: <20070515014344.GA8850@gondor.apana.org.au>
References: <d1af83620705100410n482f4f9h428b7cab5501d963@mail.gmail.com> <20070514173823.GA7137@dreamland.darkstar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514173823.GA7137@dreamland.darkstar.lan>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 07:38:23PM +0200, Luca Tettamanti wrote:
> I'm running git 705962cc (which is a commit after -rc1) and I still see
> the OOPS on boot. The patch above is already applied though. Note that
> I'm using the SLAB allocator:
> 
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> # CONFIG_SLOB is not set
> 
> 
> Ending clean XFS mount for filesystem: dm-4
> BUG: unable to handle kernel paging request at virtual address 6b6b6ceb

Please send me your .config file.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
