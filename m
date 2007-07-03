Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbXGCWf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbXGCWf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbXGCWft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:35:49 -0400
Received: from pat.uio.no ([129.240.10.15]:33615 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbXGCWft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:35:49 -0400
Subject: Re: [-mm patch] #if 0
	mm/backing-dev.c:congestion_wait_interruptible()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070703144843.4d402c32.akpm@linux-foundation.org>
References: <20070701202051.GG10869@stusta.de>
	 <20070703144843.4d402c32.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 18:35:36 -0400
Message-Id: <1183502136.6494.74.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.122)
X-UiO-Scanned: 23401B287D436E10E4AA87E181A683693082F747
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 197 total 2701256 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 14:48 -0700, Andrew Morton wrote:
> On Sun, 1 Jul 2007 22:20:51 +0200
> Adrian Bunk <bunk@stusta.de> wrote:
> 
> > congestion_wait_interruptible() is no longer used.
> 
> We might as well just delete it?

I agree. We're better off deleting it, but either would be fine by me.

Trond

