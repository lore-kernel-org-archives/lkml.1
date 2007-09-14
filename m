Return-Path: <linux-kernel-owner+w=401wt.eu-S932387AbXINOlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbXINOlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbXINOlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:41:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:62245 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbXINOlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:41:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cO3LHbVzBs81N4vp5U56krNXFOgITmmlTGvtyO+psgHGdkRGbSQ7PouDQrpi0rvGAx1/BP8/OPinVoeMM9KQMpxKmhouNpr5a0e8DxYA8QIaB7dlqmbmDFvpGTGcFmQlCofJrxxNr84prUZla2KUCM8IiQiN04EdcLMxVEG6pU0=
Message-ID: <46EA9D09.3030809@gmail.com>
Date: Fri, 14 Sep 2007 16:39:05 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jon Ivar Rykkelid <jonry@pvv.org>, Prakash Punnoor <prakash@punnoor.de>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8EABF.3060409@pvv.org> <46E953D7.5070305@gmail.com> <46E97AFF.30202@pvv.org> <200709141529.11363.prakash@punnoor.de> <46EA97F0.9000300@pvv.org> <46EA99CD.8030009@garzik.org>
In-Reply-To: <46EA99CD.8030009@garzik.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jon Ivar Rykkelid wrote:
>> Prakash Punnoor wrote:
>>> I don't think it will matter, as adma doesn't affect MCP51, but only
>>> nforce4. So I'd look for other trouble makers.
>>>   
>> Robert told me. (And you're correct - It didn't help).
> 
> Yes, it was already in slow-and-safe mode.
> 
> 
>> I'm going to test another (identical) motherboard this evening to
>> establish whether it could be a HW-issue.
> 
> Not just motherboard.  It is more likely to be a cable, drive or PSU
> problem.

I don't think it's cable as the problem occurs on multiple ports.  My
bet is either the controller or PSU.

Thanks.

-- 
tejun
