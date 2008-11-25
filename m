Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYKYI7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYKYI7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYKYI7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:59:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYKYI7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:59:23 -0500
Date: Tue, 25 Nov 2008 03:59:04 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, Zhaolei <zhaolei@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: LTTng kernel integration roadmap, update
Message-ID: <20081125085904.GA11191@infradead.org>
References: <20081124112842.GA15615@Krystal> <20081124114124.GA32459@infradead.org> <20081124122055.GA18626@Krystal> <20081125082414.GA28031@infradead.org> <20081125085722.GJ20928@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125085722.GJ20928@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 03:57:22AM -0500, Theodore Tso wrote:
> I agree that we should have a text-based output format for kernel
> hackers, as well as a binary high volume format.  I'd argue also that
> since the text-based one would be used by kernel hackers, we don't
> need to worry so much about keeping the format absolutely stable from
> kernel version to kernel version (and it's not worth it to add version
> tags to the text stream); people who care about a long-term, stable
> interface should use the binary output format, IMHO.  
> 
> I'm not sure everyone will agree with me, but I think it helps to
> simplify the effort behind the text-based output.

Yes, agreed.

