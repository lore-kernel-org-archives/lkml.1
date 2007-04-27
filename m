Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbXD0Hug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbXD0Hug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbXD0Hug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:50:36 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:30101 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbXD0Hud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:50:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CETj+O9I84FDooMXYImW8MZ3EZzWVszilNCeEhB65SryVjbgdC/0ZsCvmZOvvaK+30zkBvSgLnILvGAIKCSiiKXBwM20Un541hFiW0es/M9XvPThPwOxCueSH+e1ZwoOT6V46dL48q2T1ti6QiKkSVnTdVkHW0P5f7gMxk+1+xo=
Message-ID: <4631AB42.3060708@gmail.com>
Date: Fri, 27 Apr 2007 10:50:26 +0300
From: Sergey Yanovich <ynvich@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
References: <20070427024113.677.qmail@web36702.mail.mud.yahoo.com>
In-Reply-To: <20070427024113.677.qmail@web36702.mail.mud.yahoo.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
>> Before you get your hopes up, this development model is not one that will get
>> your code merged upstream. You should really try to work with Alex, not side
>> step him. Drivers are rarely complex enough to warrant, or even have room for, a
>> rewrite. And judging from your code it looks more like reorganising the code
>> that's already there.
>
> It is a sad truth. Instead of raising real issues that may remain in the driver, I was presented
> with "non-proof" that bus-adapter-device architecture I'm using is somehow bad and the driver
> should be turned into a monolithic blob, using config variables to disable unneeded functionality.
> Considering, that udev handles automatic loading of the drivers just fine (so it's not an end user
> issue at any rate), I don't see any justification for the change.

I may be doing something the wrong way. I absolutely don't intend to
start flames in this list.

Alex, your driver is great. You have done enormous amount of work,
reverse engineering proprietary drivers. Since the territory you work on
is unchartered, you can choose any design model, you see appropriate.

However, since we are working in an open community, everyone can give
his opinion on this issue. The commenter must definitely back his words
with real arguments. The patch at the top of this thread is such an
argument. You may or may not care about it, at will.

I have submitted my version only after I have failed to find a stable
version of your driver for the current kernel. If there is one, just
post link to the patch. If not, let's make one.
