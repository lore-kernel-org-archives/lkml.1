Return-Path: <linux-kernel-owner+w=401wt.eu-S934504AbYDQSCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504AbYDQSCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764557AbYDQSCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:02:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764266AbYDQSCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:02:24 -0400
Date: Thu, 17 Apr 2008 11:01:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417110135.08b076ac.akpm@linux-foundation.org>
In-Reply-To: <20080417114900.GA17033@infradead.org>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<84144f020804170045s24cbb802u3358ec6b5d391a10@mail.gmail.com>
	<20080417012051.ed56f4ab.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0804171130090.4929@sbz-30.cs.Helsinki.FI>
	<84144f020804170134k4c98f022xc247442592fb1a44@mail.gmail.com>
	<20080417014217.ab0453a9.akpm@linux-foundation.org>
	<20080417114900.GA17033@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 07:49:00 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Apr 17, 2008 at 01:42:17AM -0700, Andrew Morton wrote:
> > Apparently that code is not being proposed for merge and it all got
> > reimplemented and moved elsewhere.  I knew nothing of this.
> 
> It's not just you, I haven't heard anythinh either :)  I'm also still
> not comfortable with adding another quick-hacker interface instead of
> making sure the existing one doesn't suck.

afaik the sysprof-vs-oprofile issue still hasn't been settled.  Maybe it's
no longer a relevant question with the new code - I just don't know. 
Everything went all quiet and then this stuff happened.
