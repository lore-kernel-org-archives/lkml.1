Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbXERVLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbXERVLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbXERVLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:11:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51811 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbXERVLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:11:45 -0400
Message-ID: <464E168E.4000403@garzik.org>
Date: Fri, 18 May 2007 17:11:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alex Volkov <avcp-lkmail@usa.net>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: aio is unlikely
References: <20070509151831.f5956b66.akpm@linux-foundation.org>	<058f01c7998e$1406e370$650df7cd@MUMBA> <20070518140624.1a4db517.akpm@linux-foundation.org>
In-Reply-To: <20070518140624.1a4db517.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Yes, if you agree with Jeff's original point.
> 
> But I don't, actually.  Sure, on some machines+workloads, AIO is more
> common than sync IO.  But I expect that when we sum across all the
> machines+workloads in the world, sync IO is more common and is hence the
> case we should optimise for.
> 
> That's assuming that the unlikely() actually does something.


For the record, I agreed with your counter-point, and retract[ed?] my 
disagreement...

	Jeff


