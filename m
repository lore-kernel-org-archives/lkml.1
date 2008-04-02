Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYDBDJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYDBDJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 23:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYDBDJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 23:09:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292AbYDBDJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 23:09:39 -0400
Date: Tue, 1 Apr 2008 20:09:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc8
In-Reply-To: <alpine.LFD.1.00.0804011948010.14670@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0804012005030.14670@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0804011257310.14670@woody.linux-foundation.org> <20080402112355.c86d9eda.sfr@canb.auug.org.au> <alpine.LFD.1.00.0804011948010.14670@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Apr 2008, Linus Torvalds wrote:
> 
> And I think that's how we all work (and how we _should_ work), but 
> sometimes people get so used to the fact that some people are fairly 
> tightly associated with certain code that they think it's about the 
> subsystem, not about the person.

Btw - don't get me wrong - we clearly do try to (and should) make merges 
easy, and it's why the kernel source code is generally pretty modular and 
we try to keep things as independent as possible. I'm not at all arguing 
against that.

I'm just trying to explain that at least personally, I just don't see that 
"modularity" and maintainership as a _primary_ issue. The primary issue is 
just the interpersonal trust people build up over time. The modularity and 
trying to keep borders is about practical concerns, and it's important 
too. But it is still secondary, I think. 

			Linus
