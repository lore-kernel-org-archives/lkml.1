Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbXCQSoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbXCQSoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 14:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbXCQSoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 14:44:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbXCQSoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 14:44:18 -0400
Date: Sat, 17 Mar 2007 14:44:09 -0400
From: Alan Cox <alan@redhat.com>
To: Paul Rolland <rol@as2917.net>
Cc: "'Tejun Heo'" <htejun@gmail.com>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: Re: [git patches] libata fixes
Message-ID: <20070317184409.GA18870@devserv.devel.redhat.com>
References: <45F509A7.8030705@gmail.com> <00a701c768bd$f8abe130$2101a8c0@donald>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00a701c768bd$f8abe130$2101a8c0@donald>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 06:59:12PM +0100, Paul Rolland wrote:
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133

That drive isn't in our current block list for NCQ but some close
relatives are in the one I've compiled so far (7B250S0). If you add it to 
the blacklist it behave ?

Also what controller ?

