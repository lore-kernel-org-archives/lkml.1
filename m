Return-Path: <linux-kernel-owner+w=401wt.eu-S965589AbXCLLQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965589AbXCLLQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965618AbXCLLQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:16:06 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:58776 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965589AbXCLLQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:16:04 -0400
Date: Mon, 12 Mar 2007 07:16:03 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
In-reply-to: <f44c5fdf0703112358j4f94998aq9e45b0a6e848551d@mail.gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Radoslaw Szkodzinski" <astralstorm@gmail.com>,
       "Mike Galbraith" <efault@gmx.de>, "Con Kolivas" <kernel@kolivas.org>,
       "ck list" <ck@vds.kolivas.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
Message-id: <200703120716.03519.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703111457.17624.kernel@kolivas.org>
 <200703111032.40296.gene.heskett@gmail.com>
 <f44c5fdf0703112358j4f94998aq9e45b0a6e848551d@mail.gmail.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007, Radoslaw Szkodzinski wrote:
>On 3/11/07, Gene Heskett <gene.heskett@gmail.com> wrote:
>> On Sunday 11 March 2007, Mike Galbraith wrote:
>>
>> Just to comment, I've been running one of the patches between 20-ck1
>> and this latest one, which is building as I type, but I also run
>> gkrellm here, version 2.2.9.
>>
>> Since I have been running this middle of this series patch, something
>> is killing gkrellm about once a day, and there is nothing in the logs
>> to indicate a problem.  I see a blink out of the corner of my eye, and
>> its gone.  And it always starts right back up from a kmenu click.
>>
>> No idea if anyone else is experiencing this or not.
>>
>> --
>> Cheers, Gene
>
>I've had such an issue with 0.20 or something. Sometimes, the
>xfce4-panel would disappear (die) when I displayed its menu.
>Very rare issue.
>
>Doesn't happen with 0.28 anyway. :-) Which looks really good, though
>I'll update to 0.30.

And I didn't see it for the few hours I was booted to 21-rc3-rsdl-0.29, 
but tar sure went berzackers.

To Con, I knew 2.6.20 worked with your earlier patches, so rather than 
revert all the way, I just rebooted to 2.6.20.2-rdsl-0.30 and I'm going 
to fire off another backup.  I suspect it will work, but will advise the 
next time I wake up.



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The hardest thing is to disguise your feelings when you put a lot of
relatives on the train for home.
