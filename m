Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYLVV1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYLVV1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYLVV06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:26:58 -0500
Received: from mirapoint3.brutele.be ([212.68.199.148]:13452 "EHLO
	mirapoint3.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbYLVV05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:26:57 -0500
Message-ID: <49500608.7030509@tvcablenet.be>
Date: Mon, 22 Dec 2008 22:26:32 +0100
From: =?UTF-8?B?RnJhbsOnb2lzIFZhbGVuZHVj?= 
	<francois.valenduc@tvcablenet.be>
User-Agent: Thunderbird 2.0.0.18 (X11/20081123)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, Keith Packard <keithp@keithp.com>
Subject: Re: [Bug #12216] Error when drm is loaded
References: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera> <vy-yJy0f3YP.A.Jo.QaYTJB@chimera> <494DFF88.9090807@tvcablenet.be> <200812212054.49511.rjw@sisk.pl>
In-Reply-To: <200812212054.49511.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Junkmail-Status: score=10/50, host=mirapoint3.brutele.be
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A0B0207.4950060A.00F9,ss=1,fgs=0,
	ip=192.168.1.2,
	so=2008-05-01 23:44:25,
	dmn=5.7.1/2008-09-02
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki a écrit :
> On Sunday, 21 of December 2008, François Valenduc wrote:
>   
>> Rafael J. Wysocki a écrit :
>>     
>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.27.  Please verify if it still should be listed and let me know
>>> (either way).
>>>
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12216
>>> Subject		: Error when drm is loaded
>>> Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
>>> Date		: 2008-12-13 09:59 (8 days old)
>>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=52440211dcdc52c0b757f8b34d122e11b12cdd50
>>>
>>>
>>>
>>>   
>>>       
>> This bug still occurs. So, it still needs to be on the regression list.
>> I have not yet seen any replies to my bug report.
>>     
>
> Thanks for the update.
>
> Rafael
>
>   
I got a reply to my bug report and I tested the patch provided by Dave
Airlie. It seems to solve the problem. The error doesn't occur anymore
when it's applied.

François
