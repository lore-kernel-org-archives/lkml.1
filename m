Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbXJXIFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbXJXIFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbXJXIEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:04:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38251 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXJXIEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:04:52 -0400
Date: Wed, 24 Oct 2007 09:04:51 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.24-rc1
Message-ID: <20071024080451.GA32690@infradead.org>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 09:19:16PM -0700, Linus Torvalds wrote:
> In short, we just had an unusually large amount of not just x86 merges, 

Btw, can we please finis up this merge a little more before we freeze
2.6.24?  The way we currently have leftovers of arch/i386/ and arch/x86_64/
is quite a nightmare and not how the other architectures were merged.

Thomas, what again prevents us from just killing these leftovers?

