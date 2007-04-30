Return-Path: <linux-kernel-owner+w=401wt.eu-S1946564AbXD3SQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946564AbXD3SQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946548AbXD3SQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:16:48 -0400
Received: from holomorphy.com ([66.93.40.71]:56681 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946564AbXD3SQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:16:47 -0400
Date: Mon, 30 Apr 2007 11:14:07 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3/6] make IRQ stacks independently configurable (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430181407.GK19966@holomorphy.com>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174405.GF19966@holomorphy.com> <20070430181124.GC14739@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430181124.GC14739@infradead.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:44:05AM -0700, William Lee Irwin III wrote:
>> Divorce IRQ stack configuration from CONFIG_4KSTACKS, as it's believed to
>> be an important safety measure regardless of stack size by some users.

On Mon, Apr 30, 2007 at 07:11:24PM +0100, Christoph Hellwig wrote:
> We should just make irqstacks the default and kill the non-irqstack code.

For mainline that sounds like a great idea to me.


-- wli
