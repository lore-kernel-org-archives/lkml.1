Return-Path: <linux-kernel-owner+w=401wt.eu-S637773AbXDSOFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637773AbXDSOFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637772AbXDSOFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:05:22 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40640 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766713AbXDSOFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:05:20 -0400
Date: Thu, 19 Apr 2007 19:42:44 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Zongyun Lai <zlai.zju@gmail.com>
Cc: sekharan@us.ibm.com, nagar@watson.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ckrm-tech] About I/O scheduler in CKRM
Message-ID: <20070419141244.GC13192@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200704191509.17971.zlai.zju@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704191509.17971.zlai.zju@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am not aware of any updates to IO scheduler other than what is listed
on the website. Chandra/Shailabh can correct me if I am wrong.

Regarding (the future of) CKRM in general, we aren't looking at
that framework now, as Linux kernel community seemed to want simpler
frameworks. A framework which is being considered for inclusion
(hopefully in near future) will be based on this:

	http://lkml.org/lkml/2007/4/6/297


On Thu, Apr 19, 2007 at 03:09:17PM +0800, Zongyun Lai wrote:
> Hello, 
>     I am currently doing something related to storage QoS. I have read the OLS 
> papers of CKRM project. I think it would be good start point for CBQ(class 
> based queuing) scheduler in storage system. However, when I refer to the code 
> in ckrm.sf.net, I found only recent release of cpurc, memrc, and res_group 
> code, isn't it? The only io related work is the io_rc.tar.bz2 located in 
> ckrm-old branch (e18 against 2.6.12). It looks like it is based on Jens' CFQ 
> scheduler. Do you still actively maintain this ckrm project? Is there any 
> recent release of the IO scheduler, or what is the future consideration in 
> developing the IO scheduer? Thanks. 
> 
> 
> Cheers , 
>         Zongyun
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by DB2 Express
> Download DB2 Express C - the FREE version of DB2 express and take
> control of your XML. No limits. Just data. Click to get it now.
> http://sourceforge.net/powerbar/db2/
> _______________________________________________
> ckrm-tech mailing list
> https://lists.sourceforge.net/lists/listinfo/ckrm-tech

-- 
Regards,
vatsa
