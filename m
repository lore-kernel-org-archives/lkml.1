Return-Path: <linux-kernel-owner+w=401wt.eu-S1762535AbXF2LHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762535AbXF2LHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 07:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757658AbXF2LGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 07:06:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56243 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415AbXF2LGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 07:06:50 -0400
Message-ID: <4684E7C6.6040300@garzik.org>
Date: Fri, 29 Jun 2007 07:06:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, acme@redhat.com
Subject: Re: Please pull from 'from_linus' branch
References: <Pine.LNX.4.64.0706290012430.15686@blarg.am.freescale.net>
In-Reply-To: <Pine.LNX.4.64.0706290012430.15686@blarg.am.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> Please pull from 'for_linus' branch of
> 
> 	master.kernel.org:/pub/scm/linux/kernel/git/galak/powerpc.git for_linus
> 
> to receive the following updates:
> 
>  drivers/net/gianfar.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Kumar Gala (1):
>       gianfar: Fix typo bug introduced by move to udp_hdr()

Why is net driver stuff no longer going through me?

Fixes are regularly going upstream.

	Jeff



