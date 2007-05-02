Return-Path: <linux-kernel-owner+w=401wt.eu-S2993411AbXEBPzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993411AbXEBPzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993414AbXEBPzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:55:24 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:51874 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993411AbXEBPzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:55:23 -0400
Date: Wed, 2 May 2007 17:55:22 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andi Kleen <ak@novell.com>, akpm@osdl.org,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/6] Create asm-i386/cmpxchg.h
Message-Id: <20070502175522.a430f216.dada1@cosmosbay.com>
In-Reply-To: <20070502153847.GC6752@c2.user-mode-linux.org>
References: <20070501182157.GA8348@c2.user-mode-linux.org>
	<200705021137.48675.ak@novell.com>
	<20070502153847.GC6752@c2.user-mode-linux.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 11:38:47 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> On Wed, May 02, 2007 at 11:37:48AM +0200, Andi Kleen wrote:
> > Doesn't apply against the latest ff tree. Can you please regenerate,
> > not losing whatever change caused it to reject?
> 
> What's the ff tree?  Is 'f' next to 'm' on your keyboard?
> 
>

My guess is ff means firstfloor :) 

https://www.x86-64.org/pipermail/discuss/2006-January/007467.html

