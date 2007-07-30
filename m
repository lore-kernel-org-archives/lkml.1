Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbXG3Eg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbXG3Eg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 00:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbXG3Egr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 00:36:47 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:12974 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbXG3Egq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 00:36:46 -0400
X-IronPort-AV: i="4.19,196,1183348800"; 
   d="scan'208"; a="46847619:sNHT23285437"
Subject: Re: [PATCH] Remove fs.h from mm.h
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk
In-Reply-To: <alpine.LFD.0.999.0707291706490.3442@woody.linux-foundation.org>
References: <20070729223613.GA5916@martell.zuzino.mipt.ru>
	 <alpine.LFD.0.999.0707291706490.3442@woody.linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 30 Jul 2007 12:42:07 +0800
Message-Id: <1185770527.22473.2.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 30 Jul 2007 04:36:41.0450 (UTC) FILETIME=[39ABBCA0:01C7D263]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 08:08 +0800, Linus Torvalds wrote:
> 
> 
> On Mon, 30 Jul 2007, Alexey Dobriyan wrote: 
> >  
> > Cross-compile tested without regressions on my two usual configs and
> (sigh): 
> >  
> > alpha              arm-mx1ads        mips-bigsur
> powerpc-ebony 
> ..
> 
> Heh. 
> 
> Kudos for going above and beyond.
> 
>         "But where is blackfin and frv?"
> 
> Thanks,
> 
>                 Linus 

Hi Alexey,

Can I do something to help this regression testing?

Please feel free to ask me.

Thanks a lot
Best Regards,
- Bryan Wu
