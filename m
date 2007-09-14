Return-Path: <linux-kernel-owner+w=401wt.eu-S1764047AbXINOZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764047AbXINOZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbXINOZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:25:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41775 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbXINOZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:25:25 -0400
Message-ID: <46EA99CD.8030009@garzik.org>
Date: Fri, 14 Sep 2007 10:25:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jon Ivar Rykkelid <jonry@pvv.org>
CC: Prakash Punnoor <prakash@punnoor.de>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8EABF.3060409@pvv.org> <46E953D7.5070305@gmail.com> <46E97AFF.30202@pvv.org> <200709141529.11363.prakash@punnoor.de> <46EA97F0.9000300@pvv.org>
In-Reply-To: <46EA97F0.9000300@pvv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Ivar Rykkelid wrote:
> Prakash Punnoor wrote:
>> I don't think it will matter, as adma doesn't affect MCP51, but only 
>> nforce4. So I'd look for other trouble makers.
>>   
> Robert told me. (And you're correct - It didn't help).

Yes, it was already in slow-and-safe mode.


> I'm going to test another (identical) motherboard this evening to 
> establish whether it could be a HW-issue.

Not just motherboard.  It is more likely to be a cable, drive or PSU 
problem.

	Jeff


