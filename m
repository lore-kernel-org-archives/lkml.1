Return-Path: <linux-kernel-owner+w=401wt.eu-S1762160AbYHFI5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160AbYHFI5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYHFIuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:50:06 -0400
Received: from smtp6.versatel.nl ([62.58.50.97]:36376 "EHLO smtp6.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765038AbYHFIuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:50:04 -0400
Message-ID: <489967E4.9060002@hhs.nl>
Date: Wed, 06 Aug 2008 10:59:16 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [GIT PATCH] hwmon updates against v2.6.26
References: <20080801041026.GI3375@mars.solarsys.private> <20080806103903.6b9eec76@hyperion.delvare>
In-Reply-To: <20080806103903.6b9eec76@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Mark, Andrew,
> 
> On Fri, 1 Aug 2008 00:10:27 -0400, Mark M. Hoffman wrote:
>> Hi Linus:
>>
>> Please pull from:
>> 	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release
>>
>> You'll get what few patches I've managed to look at in the last few months,
>> including a patch to MAINTAINERS which makes it official.  I'm sorry I was
>> not able to keep up - I should have admitted defeat much sooner.
> 
> I'm sad to see you go (and can only hope that you won't leave the
> project entirely). But I would also like to thank you for the good work
> you've done. Even if it was short, everything you did is done and
> that's something you can be proud of. Especially given the conditions
> in which you started in this new role - please forgive me for that.
> 

All I can see really is +1, sad to see you go and thanks for all the work done!

>> To all lm-sensors/hwmon developers: please resend/CC patches to Andrew.
> 
> I have a number of hwmon patches in my local kernel tree which I wrote
> and that have been reviewed by a trusted developer, or that have been
> posted to the lm-sensors list and that I have reviewed. I consider
> these ready to go upstream. I plan to gather these into a public tree
> and push them to Linus today or tomorrow. In the future, I will
> probably have such a tree available to be included in linux-next.
> 

I too don't want to see any patches get dropped, so I'll try to step up a 
little with regards to reviewing hwmon patches, I would be grateful if you 
could incorporate any patches Acked by me in said tree. Esp since my git-fu 
isn't all that good.

> Don't get me wrong, I am _not_ volunteering to become the new hwmon
> subsystem maintainer.

Don't get me wrong either, I will try to step up my reviewing but I am _not_ 
volunteering to become the new hwmon subsystem maintainer either. I'm just 
starting a new job and with that combined with that I'm doing a lot of v4l work 
lately, I simply don't have the time for this.

> In the future, I would like to suggest to have 2 hwmon subsystem
> maintainers instead of 1. Apparently none of us has the time to do all
> the work, but maybe some of us would have the time to do half of it.
> This is the path I took for the i2c subsystem, and while the change is
> still fairly recent, it seems to be working well enough.
> 

+1


Regards,

Hans

