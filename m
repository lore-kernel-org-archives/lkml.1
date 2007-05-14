Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbXENNjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbXENNjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 09:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbXENNi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 09:38:57 -0400
Received: from mail.tmr.com ([64.65.253.246]:36106 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434AbXENNi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 09:38:56 -0400
Message-ID: <46486685.4000606@tmr.com>
Date: Mon, 14 May 2007 09:39:17 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: undeprecate raw driver.
References: <20070513163220.GA31902@redhat.com> <Pine.LNX.4.61.0705131835110.9570@yvahk01.tjqt.qr> <Pine.LNX.4.64.0705131239200.942@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705131239200.942@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Sun, 13 May 2007, Jan Engelhardt wrote:
> 
>> On May 13 2007 12:32, Dave Jones wrote:
>>
>>> Despite repeated attempts over the last two and half years, this
>>> driver seems somewhat persistant.  Remove its deprecated status as
>>> it has existing users who may not be in a position to migrate their
>>> apps
>> At least keep the "it's obsolete" Kconfig description. We don't want
>> new users/projects to jump on /dev/raw.
> 
> i just *know* this is a mistake, but i'm going to take one more shot
> at distinguishing between deprecated and obsolete.
> 
> as i understand it, the raw driver is *deprecated*.  that is, it's
> still there, it's still supported, people are still using it but its
> use is *seriously* discouraged and everyone should be trying to move
> off of it at their earliest possible convenience.
> 
> that is *not* the same as "obsolete" which should mean that that
> feature is dead, dead, DEAD and *no one* should be using it anymore.
> 
> yes, i realize it sounds like splitting hairs, but it's this malleable
> definition of "deprecated" that's causing all of this trouble in the
> first place -- the fact that the raw driver is currently listed as
> "obsolete" when it is, in fact, only deprecated.
> 
> in short, do *not* remove its "deprecated" status.  rather, remove its
> "obsolete" status and *make* it deprecated.
> 
Correct. Like the weird lady next door who fancies you, it's old, it's 
ugly, but it's not likely to go away any time soon.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
