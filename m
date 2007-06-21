Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbXFUUsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbXFUUsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbXFUUs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:48:29 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3822 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbXFUUs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:48:28 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <aoliva@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Date: Thu, 21 Jun 2007 13:48:17 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEINEMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <orps3pjd4c.fsf@oliva.athome.lsd.ic.unicamp.br>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 21 Jun 2007 13:48:45 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 21 Jun 2007 13:48:49 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Wouldn't that defeat the entire purpose of the GPLv3? Couldn't
> > I take any
> > GPLv3 program, combine it with a few lines of Linux code, and
> > Tivoize the
> > result?

> No.  This is not permission to relicense.  This is permission to
> combine.  Each author still gets to enforce the terms of her own code.

This makes no sense. We are not talking mere aggregation here, we are
talking developmental convergence. If I wrote some code that was in the
Linux kernel, how can I enforce the terms of my code (guaranteed write to
Tivoize) in the derivative work that it becomes mixed with?

> So a tivoizer would have to take out the code licensed under the
> GPLv3, and use only the code that permits tivoization.  Same as today,
> but without the possibility of cooperation for licensees who don't
> tivoize.

I am baffled how this could possibly work. You understand that the GPLv2
specifically guarantees that any derivative work will be Tivoizable and the
people who chose the GPLv2 specifically want it that way?

If I chose the GPLv2 over the GPLv3 as a conscious choice, that means I want
people to be able to Tivoize any derivative work made from my work that is
distributed.

DS


