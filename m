Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbXINSin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbXINSin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbXINSie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:38:34 -0400
Received: from ox.emgs.com ([194.248.190.99]:53129 "EHLO ox.emgs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbXINSie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:38:34 -0400
Message-ID: <46EAD526.1040601@pvv.org>
Date: Fri, 14 Sep 2007 20:38:30 +0200
From: Jon Ivar Rykkelid <jonry@pvv.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Prakash Punnoor <prakash@punnoor.de>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8EABF.3060409@pvv.org> <46E953D7.5070305@gmail.com> <46E97AFF.30202@pvv.org> <200709141529.11363.prakash@punnoor.de> <46EA97F0.9000300@pvv.org> <46EA99CD.8030009@garzik.org> <46EA9D09.3030809@gmail.com> <46EAAA9A.1020903@pvv.org> <46EAAF99.6030809@garzik.org>
In-Reply-To: <46EAAF99.6030809@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jon Ivar Rykkelid wrote:
>
>> I'm going to test another (identical) motherboard this evening to 
>> establish whether it could be a HW-issue.
>
> Not just motherboard.  It is more likely to be a cable, drive or PSU 
> problem.

>> It is NOT the PSU, nor is it cables, as all the drives work well 
>> using the same cables + PSU (in the same box) if I connect them to my 
>> other two controllers (in that same box).
>
>
> It's sometimes the combination that matters most.  You cannot really 
> make that determination yet.
>

Whatever.
(Though I must confess, that in spite of my Master degree in Electrical 
Engineering and extensive HW experience, I can not for the life of me 
understand how you can find it more likely to be cables (that work fine 
with other controllers), disks (that also work fine with other 
controllers) or the power-supply (that also works fine with exactly the 
same things connected to it) rather than the motherboard's 
SATA-controller (that is the item that actually is reported to fail in 
the first place). - Sure, I'm well aware that sometimes the combination 
of HW matters, but to my experience we're normally not talking about 
"dumb" stuff like cables and PSU if that is the issue.)

Anyway, I have just changed to the other (identical) motherboard, and 
things are running just fine at the moment...
I'll let you know if they start acting up (as they did before). If not I 
guess the fault was with the motherboard and not the driver - Guess 
we'll know pretty soon...

Thanks for all your effort, gents, let's hope it all works now!

BR
Jon Ivar

