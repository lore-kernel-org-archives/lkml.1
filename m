Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbYHYT7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbYHYT7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbYHYT7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:59:46 -0400
Received: from main.gmane.org ([80.91.229.2]:53099 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198AbYHYT7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:59:45 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux,   post-2.6.27-rc1
Date: Mon, 25 Aug 2008 16:12:53 -0400
Message-ID: <48B31245.4040505@tmr.com>
References: <20080802184554.GB715@fieldses.org>	<87abfvm4cc.fsf@burly.wgtn.ondioline.org>	<877iayy4qc.fsf@burly.wgtn.ondioline.org>	<18581.40960.737792.454035@notabene.brown>	<87r696l1yo.fsf@burly.wgtn.ondioline.org>	<18582.32935.501672.689845@notabene.brown>	<87fxpll5zq.fsf@burly.wgtn.ondioline.org>	<87y73dcd60.fsf@burly.wgtn.ondioline.org>	<1217860597.12535.2.camel@localhost>	<87hca05ws4.fsf@burly.wgtn.ondioline.org>	<20080804205908.GA29890@fieldses.org>	<1217895418.7951.7.camel@localhost>	<8763qg5don.fsf@burly.wgtn.ondioline.org>	<1217910862.7951.22.camel@localhost> <871w145ar3.fsf@burly.wgtn.ondioline.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: nfsv4@linux-nfs.org, linuxppc-dev@ozlabs.org
X-Gmane-NNTP-Posting-Host: pool-71-245-142-197.albyny.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <871w145ar3.fsf@burly.wgtn.ondioline.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Collins wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:

>> Also, how old is the machine? Any chance you're just seeing random
>> memory corruption?
> 
> It's about four years old.  It was in storage for about six months and I
> got it repaired a few weeks ago (display cable and inverter).  The sort
> of crazy crap I've been reporting certainly smacks of memory corruption.
> But on the other hand, 2.6.25 (Debian's) and 2.6.26 (my own) have been
> trouble-free.
> 
While it is possible that the new kernel tickles a hardware bug and all 
the old ones don't, I would put my $ on the kernel being the issue.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

