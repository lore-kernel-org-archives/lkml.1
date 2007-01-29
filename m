Return-Path: <linux-kernel-owner+w=401wt.eu-S933031AbXA2B0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbXA2B0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 20:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbXA2B0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 20:26:18 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:41753 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933031AbXA2B0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 20:26:17 -0500
Message-ID: <45BD4D2C.2010306@student.ltu.se>
Date: Mon, 29 Jan 2007 02:26:04 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>, Andrew Morton <akpm@osdl.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [SCRIPT] Remove "space damage" from patches
References: <45BD177D.6060907@student.ltu.se> <slrnerqapg.f71.olecom@flower.upol.cz> <45BD3AF7.4070902@student.ltu.se> <slrnerqgj0.f71.olecom@flower.upol.cz>
In-Reply-To: <slrnerqgj0.f71.olecom@flower.upol.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:
> 29-01-2007, Richard Knutsson:
>   
>> Oleg Verych wrote:
>>     
>>> Nack, big and fat. It's userspace problem.
>>>
>>> If our "developers" can't use or update their every-day-tools, it's a
>>> shame. And this is not trolling: i'm using Jed and GNU Emacs, both are
>>> ok with whitespace "production".
>>>       
>> Oh, I hope I didn't give the impression I wanted it in the kernel (that 
>> is why i labeled it as SCRIPT and not PATCH), as you said it is a 
>> userspace problem. I just thought a simple script to remove those 
>> whitespace could help in an imperfect world. I prefer kate since then 
>> you can see where the tabs begins (and other features).
>>     
>
> Just to give you idea, how imperfect it is:
> <http://marc.theaimsgroup.com/?l=linux-mm-commits&m=116198944205036&w=2>
>
> Anyway, i still think programmers *must* take care of it, if they think
> they _are_ Programmers. IMHO LKML already gives obligation to be one
Then I hope you don't mind me asking, why is there (L)indent? Everyone 
can make a mistake and if your editor does not auto-format then there 
may be a whitespace straying.
I also guess you saw that the script is _not_ for cleaning up 
source-files (can be intrusive and is better to be fixed when fixing 
something else), but patches. So if a maintainer does not have anything 
to easily fix those, they might want a simple script to do the work 
(otherwise I believe they just deleted my mail ;) ).

As I said in the posting, it is just if someone is interested in it, 
otherwise you have a Del-button.

Richard Knutsson

