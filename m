Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbXCDRi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbXCDRi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 12:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXCDRi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 12:38:28 -0500
Received: from www.osadl.org ([213.239.205.134]:59929 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751860AbXCDRi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 12:38:27 -0500
Subject: Re: 2.6.21-rc2-git3 soft lockup detected on CPU#0 (crash dump
	kernel)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <6bffcb0e0703040915h442b4d6cq8bb47cd961165916@mail.gmail.com>
References: <6bffcb0e0703031531h3f0a86c6sda2522c0ca504765@mail.gmail.com>
	 <1173018209.24738.135.camel@localhost.localdomain>
	 <6bffcb0e0703040636q5a4ed3ekf5a0461052e8e018@mail.gmail.com>
	 <1173022668.24738.141.camel@localhost.localdomain>
	 <6bffcb0e0703040828j46a339c2ofabf7c0e20f6ae09@mail.gmail.com>
	 <1173026442.24738.143.camel@localhost.localdomain>
	 <6bffcb0e0703040847g1c04940bm4c22895ec2540bd1@mail.gmail.com>
	 <1173027823.24738.156.camel@localhost.localdomain>
	 <6bffcb0e0703040915h442b4d6cq8bb47cd961165916@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 04 Mar 2007 18:44:23 +0100
Message-Id: <1173030263.24738.169.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-04 at 18:15 +0100, Michal Piotrowski wrote:
>
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-git3-kdump/log2.txt
> 

Kernel command line: .... irqpoll ....
Misrouted IRQ fixup and polling support enabled

It might be related to irqpoll. Not sure how to track that one down.

	tglx


	


