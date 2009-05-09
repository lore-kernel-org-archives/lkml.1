Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZEIQf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZEIQf7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZEIQfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:35:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbZEIQfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:35:40 -0400
Date: Sat, 9 May 2009 09:24:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ming Lei <tom.leiming@gmail.com>
cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       video4linux-list@redhat.com, mchehab@infradead.org
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
In-Reply-To: <20090509112819.759594d5@linux-lm>
Message-ID: <alpine.LFD.2.01.0905090923370.3586@localhost.localdomain>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <200904202208.23899.laurent.pinchart@skynet.be> <d82e647a0904201847n403424efnb5a0c40a4cac365d@mail.gmail.com> <200904220121.12002.laurent.pinchart@skynet.be> <20090509112819.759594d5@linux-lm>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 May 2009, Ming Lei wrote:
> 
> Rc5 has been released today, why isn't this patch accepted by upstream
> now?  It is really a bug fix.

I can take it directly, but was hoping to get it through the regular DVB 
tree. Haven't had a DVB update request yet (or maybe it got lost?)

		Linus
