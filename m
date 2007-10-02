Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbXJBNoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbXJBNoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbXJBNoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:44:38 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:36581 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbXJBNoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:44:37 -0400
Date: Tue, 2 Oct 2007 17:40:23 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Mark Lord <lkml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
Message-ID: <20071002174023.0a70a93e@localhost>
In-Reply-To: <47020D12.5090402@gmail.com>
References: <20070930160548.235be972@localhost>
	<20070930152908.1f58d39d@the-village.bc.nu>
	<20070930164610.20818867@localhost>
	<46FFBB2D.6060004@garzik.org>
	<46FFDC5A.7070509@rtr.ca>
	<46FFDCE5.4060900@gmail.com>
	<46FFE047.7030102@rtr.ca>
	<46FFE218.5000607@gmail.com>
	<46FFF0F4.7040809@rtr.ca>
	<46FFF290.2090005@rtr.ca>
	<47020D12.5090402@gmail.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 18:19:14 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Yeah, "World's first" is a pretty good clue indicating "broken".
> Blacklisting it seems like a good idea after all.

OT: I cannot test anything NCQ related for a while because the Intel
Mobo departed yesterday, so I'm on a different board without NCQ
support  ;)

-- 
	Paolo Ornati
	Linux 2.6.23-rc8generic-ga64314e6 on x86_64
