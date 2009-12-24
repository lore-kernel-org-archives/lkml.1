Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbZLXH4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbZLXH4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 02:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbZLXH4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 02:56:07 -0500
Received: from mailget.neusoft.com ([210.83.25.69]:54873 "EHLO
	mailgate.neusoft.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbZLXH4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 02:56:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5841"; a="5696127"
Date: Thu, 24 Dec 2009 15:58:13 +0800 (CST)
From: fengxiangjun <fengxiangjun@neusoft.com>
Subject: Re: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
In-reply-to: <4B331D93.2010000@kernel.org>
X-X-Sender: fengxj@darkstar.example.net
To: Tejun Heo <tj@kernel.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Message-id: <alpine.LNX.2.00.0912241557170.1682@darkstar.example.net>
MIME-version: 1.0
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
References: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net>
 <4B30134C.1050609@gmail.com>
 <alpine.LNX.2.00.0912220859060.1686@darkstar.example.net>
 <51f3faa70912211708j200ab584wa835ffe50981415e@mail.gmail.com>
 <alpine.LNX.2.00.0912220955341.1696@darkstar.example.net>
 <4B31DB17.4050509@kernel.org>
 <alpine.LNX.2.00.0912231719440.1694@darkstar.example.net>
 <4B331957.7030906@kernel.org>
 <alpine.LNX.2.00.0912241535340.1682@darkstar.example.net>
 <4B331D93.2010000@kernel.org>
Content-Transfer-Encoding: 7bit
Content-Type: TEXT/PLAIN; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, I'll try. Please wait.

Thanks.

On Thu, 24 Dec 2009, Tejun Heo wrote:

> Hello,
> 
> On 12/24/2009 04:45 PM, fengxiangjun wrote:
> > Hi, I can not capture the full failing boot log.
> > The kernel panic, and shift + pageup does not work. 
> > 
> > With output to serial console, the problem goes away.
> 
> Ah... right, I forgot about this.
> 
> > I think with an initrd, I can reproduce the problem and capture the
> > full failing boot log.  But with an initrd, there's no
> > problem. Every thing works fine.
> 
> Hmmm.... can you please try netconsole?  Netconsole usually doesn't
> introduce much delay and should be able to extract the log without
> affecting timings.
> 
> Thanks.
> 
> -- 
> tejun
> 
---------------------------------------------------------------------------------------------------
Confidentiality Notice: The information contained in this e-mail and any accompanying attachment(s) 
is intended only for the use of the intended recipient and may be confidential and/or privileged of 
Neusoft Corporation, its subsidiaries and/or its affiliates. If any reader of this communication is 
not the intended recipient, unauthorized use, forwarding, printing,  storing, disclosure or copying 
is strictly prohibited, and may be unlawful.If you have received this communication in error,please 
immediately notify the sender by return e-mail, and delete the original message and all copies from 
your system. Thank you. 
---------------------------------------------------------------------------------------------------

