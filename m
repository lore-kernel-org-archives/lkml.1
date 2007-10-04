Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbXJDUtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbXJDUtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759272AbXJDUsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:48:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54253 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758175AbXJDUsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:48:42 -0400
Date: Thu, 4 Oct 2007 21:52:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Andi Kleen <ak@suse.de>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc][patch 2/3] x86: fix IO write barriers
Message-ID: <20071004215255.33f05e92@the-village.bc.nu>
In-Reply-To: <20071004190837.GD23300@redhat.com>
References: <20071004052153.GA15131@wotan.suse.de>
	<200710042021.59704.ak@suse.de>
	<20071004184107.GC23300@redhat.com>
	<200710042058.27640.ak@suse.de>
	<20071004190837.GD23300@redhat.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  > > "Worth about 10-20% performance" according to the 2.4.18pre9-ac4
>  > > release notes: http://www.linuxtoday.com/news_story.php3?ltsn=2002-02-14-015-20-NW-KN
>  > 
>  > Are there numbers for a newer kernel available too?
> 
> no idea, my winchips died about 5 years ago

Got a couple here just need a mainboard 8)
