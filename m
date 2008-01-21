Return-Path: <linux-kernel-owner+w=401wt.eu-S1762353AbYAUPgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762353AbYAUPgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 10:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764042AbYAUPb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 10:31:57 -0500
Received: from sd-6163.dedibox.fr ([88.191.46.45]:4957 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764018AbYAUPbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 10:31:55 -0500
Message-ID: <4794BAD5.7030606@free-electrons.com>
Date: Mon, 21 Jan 2008 16:31:33 +0100
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86:	fix	unconditional	arch/x86/kernel/pcspeaker.c?compiling
References: <200801171643.49301.michael-lists@free-electrons.com>	 <478F8AEC.1080209@free-electrons.com>	 <1200590031.5332.19.camel@cinder.waste.org>	 <200801172315.29976.michael-lists@free-electrons.com>	 <20080118110252.GA17397@elte.hu> <47909821.1090907@free-electrons.com>	 <20080118122540.GH11044@elte.hu> <20080118122926.GA15216@elte.hu>	 <4790A385.800@free-electrons.com>	 <1200664214.4001.24.camel@cinder.waste.org>	 <4790D3E3.4060409@free-electrons.com> <1200676219.3835.8.camel@cinder.waste.org>
In-Reply-To: <1200676219.3835.8.camel@cinder.waste.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2008 06:10 PM, Matt Mackall wrote:
>> Sounds fine! Don't hesitate to let us know about the lower-hanging fruit
>> you're thinking about. Here are the main things I have so far:
>>
>>     * Ideas in the existing Linux-Tiny patchset.
>>     * Disable support for non-Intel processors in x86 (cyrix.c,
>>       centaur.c, transmeta.c, nexgen.c, umc.c in arch/x86/kernel/cpu).
>>       As far as I remember, I saved 15 KB when I first experimented with
>>       this).
>>     
>
> Isn't that already in -tiny?
>   
Oops, yes! I'll update these patches and post them again as soon as I
get a chance (hopefully soon).

Thanks for your support,

:-)

Michael.

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

