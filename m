Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbYGaQkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbYGaQkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYGaQkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:40:04 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:19033 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYGaQkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:40:01 -0400
X-BigFish: VPS-34(z34a4lz1432R98dR4015M1805M936fQzz10d3izzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <4891EB82.9060703@am.sony.com>
Date: Thu, 31 Jul 2008 09:42:42 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: dwmw2@infradead.org, torvalds@linux-foundation.org,
       thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, michael@free-electrons.com
Subject: Re: [patch 0/4] [resend] Add configuration options to disable features
 not needed on embedded devices
References: <20080731092703.661994657@free-electrons.com>	<20080731.024027.162488608.davem@davemloft.net>	<1217497912.3454.95.camel@pmac.infradead.org> <20080731.025547.35826309.davem@davemloft.net>
In-Reply-To: <20080731.025547.35826309.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2008 16:39:48.0856 (UTC) FILETIME=[0C2EBF80:01C8F32C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> Date: Thu, 31 Jul 2008 10:51:52 +0100
> 
>> But there are a lot of people who really don't need these features
>> and really want the option of leaving them out.
> 
> I'll say it one last time.
> 
> If you have ipv4 enabled, you need ETHTOOL.

I've been using and administering Linux for 16 years,
and using it successfully in embedded projects for 10.
Until I stumbled upon this patch in Linux-tiny, I had
never heard of ethtool.  Sony has shipped hundreds
of thousands of products with ETHTOOL turned off.

It sounds like you don't want to talk about it any more,
but could you please give me the 30-second overview
of why ETHTOOL is required for proper ipv4 operation?

If Sony is shipping network-buggy products I certainly
want to know about it.

Sorry if I missed an earlier explanation.

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

