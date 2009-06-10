Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbZFJWVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbZFJWVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZFJWVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:21:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753651AbZFJWVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:21:14 -0400
Date: Wed, 10 Jun 2009 15:20:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mingo@elte.hu, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com, jeremy@goop.org
Subject: Re: [GIT PULL] x86/xen changes for v2.6.31
Message-Id: <20090610152056.b463fcb1.akpm@linux-foundation.org>
In-Reply-To: <20090610150314.c1593e6e.akpm@linux-foundation.org>
References: <20090610215423.GA31788@elte.hu>
	<20090610150314.c1593e6e.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009 15:03:14 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 10 Jun 2009 23:54:23 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Linus,
> > 
> > Please pull the latest x86-xen-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-xen-for-linus
> > 
> > ...
> >
> > Jeremy Fitzhardinge (32):
> >       mm: disable preemption in apply_to_pte_range
> > ...
> >       mm: allow preemption in apply_to_pte_range
> 
> I think these cancel each other out, don't they?

They do.

> It's strange that I cant find them in linux-next

oop, I was looking at the wrong tree.

