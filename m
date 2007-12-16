Return-Path: <linux-kernel-owner+w=401wt.eu-S1765254AbXLPWpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765254AbXLPWpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 17:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760628AbXLPWpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 17:45:04 -0500
Received: from mail.tmr.com ([64.65.253.246]:53397 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbXLPWpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 17:45:01 -0500
Message-ID: <4765AED1.6090700@tmr.com>
Date: Sun, 16 Dec 2007 18:03:45 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: matti.aarnio@zmailer.org, linux-kernel@vger.kernel.org
Subject: Re: Does vger.kernel.org automatically drop spams?
References: <200712052225.IHJ09818.MQLtJOFOSFHVOF@I-love.SAKURA.ne.jp>	<20071205133545.GV6372@mea-ext.zmailer.org> <200712052245.AIH87554.JSOFFLFtVOOQMH@I-love.SAKURA.ne.jp>
In-Reply-To: <200712052245.AIH87554.JSOFFLFtVOOQMH@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Hello.
> 
> Matti Aarnio wrote:
>>> Does vger.kernel.org have spam filter and automatically drop spams?
>> Yes.  Yes.  And even worse: SILENTLY drop it.  The reason was:
>>
>>      global taboo header: m!OJFS!
>>
>> I don't recall why that was declared taboo, but it apparently bites
>> on References: headers..  Entirely unintentional, I assure you.
> 
> I see. Thank you.
> 
> Well, may be my address was registered as a spammer.
> 
> What should I do to post my message?
> 
> Should I use different From: address?
> Should I stop sending to multiple lists?
> 
Since this was in the References header, stop replying to messages with 
OFJS in the Message-Id would do it, if I read Matti's reply correctly.

Were other replies also blocked, Matti? Does the filter hit References: 
but not In-Reply-To: and so apply to responses to the post found in a 
newsgroup but not on the mailing list?

>> We (the postmasters) can approve your messages for posting, but it
>> will take a few hours that I get off work, and have time to do it.
>> (I need to do some additional setups, all those lists are not
>> in my existing majordomo password database..)
> 
> Should I wait for your approval?
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
