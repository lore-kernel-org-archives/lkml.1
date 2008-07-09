Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbYGINbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbYGINbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYGINbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:31:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:39636 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYGINbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:31:37 -0400
Date: Wed, 9 Jul 2008 06:31:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/17] Series to introduce WARN()... a WARN_ON() variant
 that takes printk arguments
Message-ID: <20080709063128.26b8d6f2@infradead.org>
In-Reply-To: <20080709044613.2546034d.akpm@linux-foundation.org>
References: <20080708093800.274504ba@infradead.org>
	<20080709101348.GA30005@elte.hu>
	<20080709041956.0c52b2d9.akpm@linux-foundation.org>
	<20080709113703.GA11191@elte.hu>
	<20080709044613.2546034d.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 04:46:13 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> Well I haven't got onto processing these patches in detail yet.  An
> open questions is why the damn thing was resubmitted from scratch
> when I've already merged it and fixed various rejects and had to fix
> several bugs in it.  Do those rejects need to be re-fixed?  Were my
> bugfixes folded back? I haven't looked yet.  I'll need to generate
> the incremental diff and see what was done.

I started with the version in -mm (and had to do one reject fix against
-next) with folding the 2 -fix's into it.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
