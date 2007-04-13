Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbXDMTFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbXDMTFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbXDMTFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:05:19 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46677 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbXDMTFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:05:17 -0400
Date: Fri, 13 Apr 2007 12:05:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALPHA: build fixes - force architecture (take 2)
Message-Id: <20070413120503.28466a25.akpm@linux-foundation.org>
In-Reply-To: <20070412211639.GA23340@twiddle.net>
References: <20070412120110.A25812@jurassic.park.msu.ru>
	<20070412211639.GA23340@twiddle.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 14:16:39 -0700
Richard Henderson <rth@twiddle.net> wrote:

> On Thu, Apr 12, 2007 at 12:01:10PM +0400, Ivan Kokshaysky wrote:
> > [CIX stuff reworked, .got change dropped as Richard suggested]
> > 
> > Override compiler .arch directive for generic kernel build.
> > 
> > Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> 
> Signed-off-by: Richard Henderson  <rth@twiddle.net>
> 

So I currently have

alpha-fix-bootp-image-creation.patch
alpha-prctl-macros.patch
alpha-fixes-for-specific-machine-types.patch
alpha-more-fixes-for-specific-machine-types.patch
alpha-build-fixes-force-architecture.patch

Which of these do you think should be in 2.6.21?
