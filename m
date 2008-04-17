Return-Path: <linux-kernel-owner+w=401wt.eu-S1762238AbYDQLtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762238AbYDQLtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbYDQLtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:49:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60556 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYDQLtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:49:08 -0400
Date: Thu, 17 Apr 2008 07:49:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080417114900.GA17033@infradead.org>
References: <20080416202338.GA6007@elte.hu> <20080417002552.5742ad65.akpm@linux-foundation.org> <84144f020804170045s24cbb802u3358ec6b5d391a10@mail.gmail.com> <20080417012051.ed56f4ab.akpm@linux-foundation.org> <Pine.LNX.4.64.0804171130090.4929@sbz-30.cs.Helsinki.FI> <84144f020804170134k4c98f022xc247442592fb1a44@mail.gmail.com> <20080417014217.ab0453a9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417014217.ab0453a9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 01:42:17AM -0700, Andrew Morton wrote:
> Apparently that code is not being proposed for merge and it all got
> reimplemented and moved elsewhere.  I knew nothing of this.

It's not just you, I haven't heard anythinh either :)  I'm also still
not comfortable with adding another quick-hacker interface instead of
making sure the existing one doesn't suck.

