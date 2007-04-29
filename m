Return-Path: <linux-kernel-owner+w=401wt.eu-S1031443AbXD2Whr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031443AbXD2Whr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031447AbXD2Whr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:37:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38595 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031443AbXD2Who (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:37:44 -0400
Date: Mon, 30 Apr 2007 00:37:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429223741.GB714@one.firstfloor.org>
References: <20070429180909.GA30604@one.firstfloor.org> <20070429214007.9ea12e96.diegocg@gmail.com> <20070429201729.GQ3468@stusta.de> <20070429225657.a501ab5a.diegocg@gmail.com> <20070429211028.GT3468@stusta.de> <6bffcb0e0704291416u402668ffo9bcaafb389228981@mail.gmail.com> <20070429212128.GU3468@stusta.de> <1177883521.5791.156.camel@localhost.localdomain> <20070429221958.GX3468@stusta.de> <1177886010.5791.166.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177886010.5791.166.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Right. Simply because these lists are assembled by someone
> 
> - who knows how to pick that reports from the mailinglists
> - who knows how to sort them in a useful way
> - who knows how to add the relevant folks on CC

That all needs to be done by someone initially yes. But then tracking what happens
afterwards is something that can be distributed. A difficult bug can take a long
time to resolve and generate a lot of messages; you don't want to require
the initial sorter to handle all that too.

It's much more scalable to let the developers update the state themselves
then once they handle the bug.

-Andi
