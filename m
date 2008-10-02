Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYJBWdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYJBWdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYJBWdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:33:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15627 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYJBWdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:33:11 -0400
Message-ID: <48E54BF4.3000600@oracle.com>
Date: Thu, 02 Oct 2008 15:32:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Steven Noonan <steven@uplinklabs.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: make MAINTAINERS slightly easier to search
References: <20081002081428.GA2022@elf.ucw.cz> <f488382f0810020208u5761a84p5cac040503f55917@mail.gmail.com> <20081002085820.3568934d.randy.dunlap@oracle.com> <20081002222003.GA1857@elf.ucw.cz>
In-Reply-To: <20081002222003.GA1857@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Thu 2008-10-02 08:58:20, Randy Dunlap wrote:
>> On Thu, 2 Oct 2008 02:08:20 -0700 Steven Noonan wrote:
>>
>>> On Thu, Oct 2, 2008 at 1:14 AM, Pavel Machek <pavel@suse.cz> wrote:
>>>> ...shall we add rule that subsystems will have "subsystem" in the name
>>>> so that search does not list all the drivers, first?
>>>>
>>>> Signed-off-by: Pavel Machek <pavel@suse.cz>
>>>> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>>>>
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index 3596d17..7345707 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -3825,7 +3825,7 @@ L:        linux-kernel@vger.kernel.org
>>>>  W:     http://tifmxx.berlios.de/
>>>>  S:     Maintained
>>>>
>>>> -SOUND
>>>> +SOUND SUBSYSTEM (ADVANCED LINUX SOUND SYSTEM, ALSA)
>>> Advanced Linux Sound System = ALSS? How about switching it to
>>> 'ADVANCED LINUX SOUND ARCHITECTURE', which fits the original acronym?
>>> :)
>> Yes, concur.  Thanks.
> 
> Fixed in my tree. Who is maintainer of MAINTAINERS file? ;-).

I would expect Andrew to merge it.
If he doesn't, then I'll try to merge it.  :)

~Randy
