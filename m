Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYEZShX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYEZShX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYEZShL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:37:11 -0400
Received: from mx.treblig.org ([80.68.94.177]:59209 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbYEZShK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:37:10 -0400
X-Greylist: delayed 2457 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2008 14:37:09 EDT
Date: Mon, 26 May 2008 18:56:10 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [CRM114spam]: [Bug 10797] Something is consuming power after shutdown
Message-ID: <20080526175610.GA28974@gallifrey>
References: <483AB443.6020807@diamondcut.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483AB443.6020807@diamondcut.com.br>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.23.1-bytemark-uml (i686)
X-Uptime: 18:51:26 up 10 days, 17:44,  1 user,  load average: 0.21, 0.07, 0.02
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Renato S. Yamane (yamane@diamondcut.com.br) wrote:
> <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
> <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=481493>

Also add a Ubuntu equivalent which is:
https://bugs.launchpad.net/ubuntu/+bug/110784

(In my case a Tosh Equium A100-306 )

> After poweroff, something still working and consuming power. So I loss 
> ~4% of my battery charge in each 12h.
> 
> If I shutdown my laptop using Kernel 2.6.24/25 when battery is 100%, 
> after 12h my battery charge go to 96% (this information is checked with 
> kpowersave and with LED available in my laptop that change color from 
> blue to yellow when battery is not FULL).

I haven't got the actual numbers, but I'd say mine is a little more -
may be 10% from memory overnight.  Certainly between a Sunday evening
and a Saturday afternoon there is nothing left for it to turn back on.

Following the thread I did notice I had w-o-l enabled; I've
disabled it - see if it makes any difference tonight.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
