Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbYABVsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbYABVsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbYABVsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:48:16 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:34700 "EHLO
	server1.example.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753631AbYABVsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:48:15 -0500
Message-ID: <477C069C.1060905@nigel.suspend2.net>
Date: Thu, 03 Jan 2008 08:48:12 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "The place to get help!" <suspend2-users@lists.tuxonice.net>
CC: suspend2-devel@lists.tuxonice.net,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Suspend2-users] [Suspend2-devel] Freezing filesystems (Was Re:
 What's in store for 2008 for TuxOnIce?)
References: <477AC060.5040004@nigel.suspend2.net>	<200801021401.23492.rjw@sisk.pl>	<477BFD7A.3060403@nigel.suspend2.net>	(sfid-20080102_221641_303169_6193472F) <200801022235.05476.Martin@lichtvoll.de>
In-Reply-To: <200801022235.05476.Martin@lichtvoll.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin.

Martin Steigerwald wrote:
> Am Mittwoch 02 Januar 2008 schrieb Nigel Cunningham:
>> Hi.
> 
> Hi,
> 
>> Rafael J. Wysocki wrote:
>>> On Wednesday, 2 of January 2008, Theodore Tso wrote:
>>>> On Wed, Jan 02, 2008 at 10:54:18AM +1100, Nigel Cunningham
>>>> wrote:
>>>>>> I would also like the TuxOnIce issues related to drivers,
>>>>>> ACPI, etc. to go to one of the kernel-related lists, but I
>>>>>> think linux-pm may be better for that due to the much lower
>>>>>> traffic.
>>>>> I guess that makes sense. I guess people can always be
>>>>> referred to LKML for the issues where the appropriate person
>>>>> isn't on linux-pm.
>>>> Hi Nigel,
>>>> 
>>>> I'd really recommend pushing the TuxOnIce discussions to LKML.
>>> CCing linux-pm (or even linux-acpi) on problem reports would
>>> still be recommended, though. :-)
>> Right. And that may make things easier as far as TuxOnIce users go
>> too. I have one user who currently subscribes to suspend2-users who
>> already tried subscribing to LKML and said he didn't like the
>> experience. Using linux-pm instead would save some pain there.
> 
> I am a bit reluctant about LKML from some of the discussions I have
> seen there and participated in during CFS / CK discussion. I really
> didn't like the tone. Its one thing to say ones own oppinion, another
> one to bash at each other as if there was no tomorrow.
> 
> This has been refreshingly different on tuxonice mailing lists. I am
> also a bit reluctant about the traffic. I already have some quite
> high traffic mailinglists with 30000-40000 mails a year, but LKML
> would top these easily I guess and I am not that sure I want to put
> that load on my mail infrastructure to follow TuxOnIce developments.
> I think this is a generic problem for testers of specific kernel
> subsystems...
> 
> But then LKML is were TuxOnIce is visible to the kernel developer 
> community.
> 
> I would appreciate linux-pm I think maybe with a guideline to CC to
> LKML in usual cases...

Thanks for your feedback. I think that's the way to go.

> BTW: toi-3.0-rc3 is rocking along nicely on my two ThinkPads (T42 and
>  T23)... I am using 2.6.23.12 with cfs-v24.1...

Great to hear!

Nigel
