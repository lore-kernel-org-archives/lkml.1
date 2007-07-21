Return-Path: <linux-kernel-owner+w=401wt.eu-S937703AbXGUN5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937703AbXGUN5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 09:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763405AbXGUN5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 09:57:47 -0400
Received: from mail.tmr.com ([64.65.253.246]:44786 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761418AbXGUN5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 09:57:46 -0400
Message-ID: <46A21105.9050402@tmr.com>
Date: Sat, 21 Jul 2007 09:58:29 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-git13 crash
References: <46A11E4B.3070002@tmr.com> <46A121DD.2090304@googlemail.com>
In-Reply-To: <46A121DD.2090304@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Bill Davidsen wrote:
>   
>> built from 2.6.22-git9 config, used oldconfig. Crashes so early it 
>> doesn't seem to get to the network card.
>>
>>   config: www.tmr.com/~davidsen/config-2.6.22-git13.gz
>>   screen dump: www.tmr.com/~davidsen/dump-2.6.22-git13.jpg
>>
>> Not much info, and probably seen elsewhere.
>>
>>     
>
> Should be fixed by this commit :
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9550b105b8646f916862aee3ab7b25020ca14159
>   
Thanks much for the quick reply, patches kernel building now.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

