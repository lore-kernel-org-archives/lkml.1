Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbZAIXia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbZAIXia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZAIXiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:38:07 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:21862 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbZAIXiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:38:05 -0500
X-Spam-Flag: NO
X-Spam-Score: -11.612
Message-ID: <4967DFD3.8070100@tremplin-utc.net>
Date: Sat, 10 Jan 2009 00:37:55 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org
Subject: Re: - lis3lv02d-separate-the-core-from-hp-acpi-api.patch removed
 from -mm tree
References: <200901091958.n09JwbJs031498@imap1.linux-foundation.org>	<20090109230003.GB2223@elf.ucw.cz> <20090109152317.ca2a2da8.akpm@linux-foundation.org>
In-Reply-To: <20090109152317.ca2a2da8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 10 Jan 2009 00:00:03 +0100
> Pavel Machek <pavel@suse.cz> wrote:
> 
>>> The patch titled
>>>      LIS3LV02D: separate the core from HP ACPI API
>>> has been removed from the -mm tree.  Its filename was
>>>      lis3lv02d-separate-the-core-from-hp-acpi-api.patch
>>>
>>> This patch was dropped because other changes were merged, which wrecked this patch
>> I'm confused. The other patch collided with leds/Makefile changes, but
>> this one applies cleanly over Linus' git (updated today)... or am I
>> doing something wrong? Could it still be pushed to Linus?
> 
> umm, sure, we can try that.
> 
> Please don't use vague terms like "the other patch".  I assume you're
> referring to lis3lv02d-merge-with-leds-hp-disk.patch?
> 
> It has more problems than a simple makefile conflict.  People keep on
> changing stuff in linux-next.  
I'm also confused because from your "-mm merge plans" mail I had
understood that both patches would be merged in 2.6.29, and they both
still apply fine on Linus' tree. How come it's a problem they conflicts
in linux-next? Is it because this is currently the merge window? Do I
have to update the patches against linux-next and send them back to you?
Let me know what you need :-)

Eric
