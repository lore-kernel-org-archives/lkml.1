Return-Path: <linux-kernel-owner+w=401wt.eu-S1762737AbYBPBH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762737AbYBPBH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 20:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbYBPBHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 20:07:19 -0500
Received: from mail.tmr.com ([64.65.253.246]:41158 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbYBPBHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 20:07:18 -0500
Message-ID: <47B6377D.4050502@tmr.com>
Date: Fri, 15 Feb 2008 20:08:13 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Driver removals
References: <fp08q7$jv0$1@ger.gmane.org> <20080214082547.GJ12383@cs181133002.pp.htv.fi> <47B5E2FD.9060908@tmr.com> <20080215222830.GA9962@cs181133002.pp.htv.fi>
In-Reply-To: <20080215222830.GA9962@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Feb 15, 2008 at 02:07:41PM -0500, Bill Davidsen wrote:
>   
>> Adrian Bunk wrote:
>>     
>>> On Wed, Feb 13, 2008 at 09:26:26PM -0500, Bill Davidsen wrote:
>>>       
>>>> ...
>>>> In general, if a driver works and is being used, until it *needs*   
>>>> attention I see no reason to replace it. I don't agree that "it 
>>>> forces  people to try the new driver" is a valid reason, being 
>>>> unmaintained is  only a problem if it needs maintenance. I am not 
>>>> going to reopen that  topic, I'm simply noting a general opposition 
>>>> to unfunded mandates, and  requiring changes to kernel, module and/or 
>>>> rc.local config is just that.
>>>>         
>>> Keeping a working unmaintained driver in the tree is not a big deal - 
>>> we have hundreds of them.
>>>
>>> But you miss the main point that removal of an obsolete driver with a  
>>> new replacement driver forces people to finally report their problems  
>>> with the new driver, thus making the new driver better.
>>>
>>>       
>> You sure are proud of that new driver! People won't use it because the  
>> old one is working fine, so you think it's fine to force them to make  
>> changes in their system to use the new driver.
>>     
>
> Sometimes what is best in the global picture is not what everyone
> subjectively considers to be the best thing for him.
>
> Well, our whole society is based on this principle...
>
>   
>> Best case is it works  
>> after costing the user some time, worst case it doesn't and breaks their  
>> system, so they stop upgrading the kernel and don't get security fixes.
>> ...
>>     
>
> Instead of sending a bug report?
>   

To get the system working.
> When removing an obsolete driver adult people suddenly start whining
> "the new driver didn't work for me when I tried it one year ago".
>
> And when asking where they reported the bug in the new driver the answer 
> is that they didn't report it.
>
> Driver development heavily relies on getting bug reports when something 
> doesn't work.

If you don't see an ethical problem in removing a working driver which 
is not taking support resources, in order to force people to test and 
debug a driver they don't now and never would need, so that it might in 
time offer them the same functionality those users already had... then I 
can never make you see why technological extortion is evil. People have 
always moved to new drivers without pushing because they were *better*, 
guess that model is dead.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


