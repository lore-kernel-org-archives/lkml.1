Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbXKGWXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbXKGWXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbXKGWW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:22:57 -0500
Received: from barracuda-out1.linkline.com ([64.30.215.67]:55149 "EHLO
	barracuda-out1.linkline.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856AbXKGWW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:22:57 -0500
X-Greylist: delayed 832 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2007 17:22:56 EST
X-ASG-Debug-ID: 1194473343-2dc001f90000-xx1T2L
X-Barracuda-URL: http://64.30.215.67:8000/cgi-bin/mark.cgi
X-Barracuda-Connect: host-66-59-225-129.static.linkline.com[66.59.225.129]
X-Barracuda-Start-Time: 1194473343
Message-ID: <4732377F.2040705@gmail.com>
Date: Wed, 07 Nov 2007 14:09:03 -0800
From: Joshua Doll <Joshua.Doll@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: Re: 2.6.34-rc1 eat my photo SD card :-(
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
References: <1193918202.8439.7.camel@rukbat>
In-Reply-To: <1193918202.8439.7.camel@rukbat>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at linkline.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Romano Giannetti wrote:
> Hi,
>
> 	I have a very possible regression to signal. This morning 2.6.24-rc1
> eat and destroyed my SD card. I have a toshiba laptop with a card slot
> and I have used it with 2.6.23-rcX and 2.6.23 without problems so far.
> This morning I put the card in, nothing happened, removed it. When I put
> it in again the filesystem in it was completely scr***ed up. 
>
> I have a flight waiting now, so I have put all the dmesgs and syslogs
> over there:
>
> http://www.dea.icai.upcomillas.es/romano/linux/info/2624-rc1-mmc/
>
> Sunday I'll be back to help debug it.
>
> Thank you very much
>
> 	Romano 
>
>   

I think the problem is you are using a kernel from the future. :-) I 
just couldn't resist.


--Joshua Doll
