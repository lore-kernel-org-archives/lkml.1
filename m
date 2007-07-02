Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbXGBTP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbXGBTP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbXGBTPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:15:49 -0400
Received: from mail.tmr.com ([64.65.253.246]:48451 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbXGBTPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:15:48 -0400
Message-ID: <46894F8F.3070607@tmr.com>
Date: Mon, 02 Jul 2007 15:18:39 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: nigel@suspend2.net
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Suspend2 is getting a new name.
References: <200707021730.57066.nigel@nigel.suspend2.net>
In-Reply-To: <200707021730.57066.nigel@nigel.suspend2.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
> Hi all.
> 
> Suspend2's name is changing to "TuxOnIce".
> 
> This is for a couple of reasons:
> 
> In recent discussions on LKML, the point was made that the word "Suspend" is 
> confusing. It is used to refer to both suspending to disk and suspending to 
> ram. Life will be simpler if we more clearly differentiate the two.
> 
> The name Suspend2 came about a couple of years ago when we made the 2.0 
> release and started self-hosting. If we ever get to a 3.0 release, the name 
> could become even more confusing! (And there are already problems with people 
> confusing the name with swsusp and talking about uswsusp as version 3!).
> 
> http://www.suspend2.net is still working at the moment, but we'll shift to 
> http://www.tuxonice.net over the next while. The wiki and bugzilla are 
> already done; email will remain on suspend2.net for a little while and git 
> trees will be renamed at the time of the next stable release.
> 
I guess this is "good news, bad news" time. The good news is that the 
"suspend with working resume" project is still active, the bad news is 
that making provisions for long term out of mainline operation sounds as 
if you have no hope of getting this code into the mainline kernel. :-(

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
