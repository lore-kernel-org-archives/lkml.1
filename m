Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbYBPSKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbYBPSKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYBPSK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:10:29 -0500
Received: from mail.tmr.com ([64.65.253.246]:41615 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbYBPSK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:10:28 -0500
Message-ID: <47B72766.9080107@tmr.com>
Date: Sat, 16 Feb 2008 13:11:50 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Driver removals
References: <fp08q7$jv0$1@ger.gmane.org> <20080214082547.GJ12383@cs181133002.pp.htv.fi> <47B5E2FD.9060908@tmr.com> <20080215222830.GA9962@cs181133002.pp.htv.fi>            <47B6377D.4050502@tmr.com> <26601.1203126747@turing-police.cc.vt.edu>
In-Reply-To: <26601.1203126747@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Fri, 15 Feb 2008 20:08:13 EST, Bill Davidsen said:
>
>   
>> can never make you see why technological extortion is evil. People have 
>> always moved to new drivers without pushing because they were *better*, 
>> guess that model is dead.
>>     
>
> And the drivers get better because the Code Fairy comes and sprinkles magic
> bugfix dust all over them? And the Code Fairy knows where to sprinkle bugfix
> dust because it can see where the Bugreport Fairy sprinkled Bugreport Dust?
>   

Drivers get better because someone who finds a benefit in them also 
finds a problem. They don't get better by developers looking for 
intermittent, probably load dependent, bugs which effect eight year old 
server hardware which was a low volume item, the developers are unlikely 
to have, and which is in use providing services, not on someone's 
desktop where it can reasonably be rebooted to test patches.
> Yes, people will move without pushing when the drivers are better.  However,
> remember that a major cultural motivation for the GPL is the concept of "give
> back".  And if a user can't be bothered to even give back enough to say
> "wow, this blows, my Frobnozz9800 doesn't work with this driver", that's a
> problem with the user.  They're getting it for free, they should at least
> give the developers the kindness of a bug report if something is broken...
>   

Not when drivers are "better" but when a new driver offers some benefit, 
be it reliability, capability, etc. When the new driver offers not a 
single benefit and the only "feature" is "possible unknown bugs," people 
are not going to change, and I don't think forcing people off working 
drivers is any more ethical than Microsoft killing XP to force people to 
VISTA. Less ethical, actually, because MSFT is looking for profit, and 
they make no pretense of caring about the users in any role but revenue 
stream.
> <insert diatribe about users who just want free-as-in-beer>....
>   

Insert it right next to the diatribe about developers who think that 
because some new feature was a lot of work that Linus *must* put it in 
the kernel, or users show show proper respect and gratitude and disrupt 
their production hardware to test and debug some new code which offers 
zero added functionality on that hardware. If you think downtime is 
"free" then you  have not been working in the right environments, or for 
the right management.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


