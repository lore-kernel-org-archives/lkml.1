Return-Path: <linux-kernel-owner+w=401wt.eu-S1751575Ab0AZFlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab0AZFlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 00:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258Ab0AZFlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 00:41:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:54562 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab0AZFlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 00:41:18 -0500
Date: Mon, 25 Jan 2010 21:41:50 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dimitrios Apostolou <jimis@gmx.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #15040] High cpu temperature with 2.6.32
Message-ID: <20100125214150.1f2e1410@infradead.org>
In-Reply-To: <201001252152.33031.rjw@sisk.pl>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	<q60Z28d_9yH.A.bxH.PZMXLB@chimera>
	<alpine.LNX.2.00.1001250115420.6323@localhost.localdomain>
	<201001252152.33031.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 21:52:32 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday 25 January 2010, Dimitrios Apostolou wrote:
> > I will let you know when this bug is fixed in a regular kernel
> > release. I just tested 2.6.32.5 and the bug persists. BTW, Arjan, I
> > think this bug will be biting other people too, see the following
> > thread: http://bugs.archlinux.org/task/17771
> 
> I don't think it's fixed, I haven't seen the Arjan's patch anywhere
> close to the mainline.
> 
> Arjan, perhaps send it directly to Linus, please (unless it's already
> waiting somewhere for merging)?

I sent it to Len and Andrew (Len as maintainer, Andrew as maintainer of
last resort)..... what more would I need?



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
