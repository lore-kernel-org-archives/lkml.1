Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbYGXS4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbYGXS4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 14:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYGXS4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 14:56:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687AbYGXS4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 14:56:24 -0400
Date: Thu, 24 Jul 2008 11:53:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Whitehouse <swhiteho@redhat.com>
cc: Alexander Viro <aviro@redhat.com>, Evgeniy Dushistov <dushistov@mail.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: parser: add const to parser token table (resend)
In-Reply-To: <alpine.LFD.1.10.0807241147160.3237@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807241150550.3237@nehalem.linux-foundation.org>
References: <1216916533.5376.1.camel@localhost.localdomain> <alpine.LFD.1.10.0807241147160.3237@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Jul 2008, Linus Torvalds wrote:
> 
> Btw, the reason I didn't even look at this at first is that there is no 
> such thing as a "parser" in the kernel, so I just dismissed the patch as 
> being to somebody else (ie a sparse thing).

Just to clarify: there obviously _is_ a "parser", but it's at such a low 
level that tagging by it doesn't much help my mental picture, when there 
are other projects I'm involved with where the "parser" is a much more 
integral and major deal.

			Linus
