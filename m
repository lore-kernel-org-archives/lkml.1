Return-Path: <linux-kernel-owner+w=401wt.eu-S935355AbYBVKHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935355AbYBVKHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYBVKGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:06:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:59594 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYBVKGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:06:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=TU8HORfYzaFV/NsumgnQQWKU1mF3Yo64kyEFwQs3BARHglWufa1Rr5AQAggcA9AqzgefLCU2T3zKjZlfuZilGFUY+4V4F0C7r8B+JU7kv6gC7Ycr/RpdMqfWJDCQ9F0ri78lWDIOlZF70LUZ1Ala6MTXZMD9vDswqriRQPDV+BU=
Date: Fri, 22 Feb 2008 11:06:30 +0100
From: Frederik Deweerdt <deweerdt@free.fr>
To: belcampo <belcampo@zonnet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hyperthreading performance oddities
Message-ID: <20080222100630.GE5906@slug>
References: <47BE9781.3030304@zonnet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BE9781.3030304@zonnet.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Henk,

On Fri, Feb 22, 2008 at 10:36:01AM +0100, belcampo wrote:
> Kernel 2.6.22.9 smp hyperthreading
> BENCHMARKs: VC: 334.042s VO:   0.053s A:   0.000s Sys:   4.049s =  338.143s
> Kernel 2.6.22.9 nonsmp/hyperthreading
> BENCHMARKs: VC: 262.008s VO:   0.031s A:   0.000s Sys:   3.528s =  265.567s
> with 2.6.17 kernel smp/hyperthreading pentium-pro as CPU
> BENCHMARKs: VC: 245.175s VO:   0.050s A:   0.000s Sys:   2.479s =  247.704s
> with 2.6.17 kernel smp/hyperthreading pentium4 optimized kernel
> BENCHMARKs: VC: 227.992s VO:   0.051s A:   0.000s Sys:   2.551s =  230.594s
I'm not familiar with mplayer benchmarks, what do they actually
measure?

Regards,
Frederik
