Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbXCHHe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbXCHHe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 02:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932932AbXCHHe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 02:34:27 -0500
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:40492 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932899AbXCHHe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 02:34:26 -0500
Message-ID: <45EFBC73.2030005@blueyonder.co.uk>
Date: Thu, 08 Mar 2007 07:34:11 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: auxsvr@gmail.com, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45E59D64.3070202@blueyonder.co.uk>	<200702281805.13822.auxsvr@gmail.com> <20070307214730.87859590.akpm@linux-foundation.org>
In-Reply-To: <20070307214730.87859590.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc restored.  Please always do reply-to-all)
>
>   
>> On Wed, 28 Feb 2007 18:05:13 +0200 auxsvr@gmail.com wrote:
>> On Wednesday 28 February 2007 17:19, Sid Boyce wrote:
>>     
>>> openSUSE 10.3 Alpha and KDE-3.5.6, xorg-x11-7.2. KDE is setup not to
>>> require a password to unlock, but it asks for password. When the screen
>>> unlocks, kwin is gone with no errors logged in /var/log/kdm or
>>> /var/log/messages. No problems with 2.6.20.
>>>
>>> Same problem on openSUSE 10.2 x86_64, KDE-3.5.5 and 2.6.21-rc2.
>>> Regards
>>> Sid.
>>>       
>> This is the linux kernel mailing list. Perhaps you should post your problem to 
>> the opensuse mailing list.
>>     
>
> 2.6.20 worked.
>
> 2.6.20-rc2 did not.
>
> Working theory: the kernel broke.
>
> Sid, the chances that anyone can work out what caused this are pretty low. 
> It would be great if you could perform a git bisection search sometime in
> the next few weeks, work out which commit caused this.
>
> Thanks.
>
>
>
>   
I shall go back to 2.6.20-git3 and work forward. Up to 2.6.20-git2 was OK.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


