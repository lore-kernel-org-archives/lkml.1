Return-Path: <linux-kernel-owner+w=401wt.eu-S1765014AbXJRWZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765014AbXJRWZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbXJRWZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:25:06 -0400
Received: from xenotime.net ([66.160.160.81]:52612 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753668AbXJRWZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:25:04 -0400
Date: Thu, 18 Oct 2007 15:25:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@qumranet.com>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: latest checkpatch
Message-Id: <20071018152502.b2f3a105.rdunlap@xenotime.net>
In-Reply-To: <4717C8CD.9010300@garzik.org>
References: <20071015182118.GA4459@shadowen.org>
	<200710161759.l9GHxnkK012590@agora.fsl.cs.sunysb.edu>
	<20071017163916.GO21136@shadowen.org>
	<20071018111352.GA17039@elte.hu>
	<20071018192521.GC21136@shadowen.org>
	<20071018193929.GA22031@elte.hu>
	<4717BBD0.7070504@qumranet.com>
	<20071018205147.GA1382@elte.hu>
	<4717C8CD.9010300@garzik.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 16:57:49 -0400 Jeff Garzik wrote:

> Ingo Molnar wrote:
> > there's "checkpatch --file" for complete files, so it can see the full 
> > context if the user passes it in.
> 
> This is new, I guess?
> 
> [jgarzik@pretzel linux-2.6]$  scripts/checkpatch.pl --file 
> drivers/ata/libata-eh.c
> Unknown option: file
> 
> Such an option would be quite useful, but does not appear in upstream.
> 
> Also, upstream lacks support for "-h" and "--help" so you get to guess 
> at the options.

Yep.

Andy has sent latest to akpm, so it could be pushed to Linus as well.

and you can also get latest at
http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/

---
~Randy
