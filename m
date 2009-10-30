Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbZJ3OIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbZJ3OIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 10:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142AbZJ3OIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 10:08:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37269 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbZJ3OII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 10:08:08 -0400
Date: Fri, 30 Oct 2009 15:08:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Greg KH <gregkh@suse.de>, Brian Swetland <swetland@google.com>,
       Eric Miao <eric.miao@canonical.com>, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Android logger: fix compiling error
Message-ID: <20091030140806.GD1481@ucw.cz>
References: <1256316741-14053-1-git-send-email-bryan.wu@canonical.com> <f17812d70910262140i63e4d2f0x708521a9287ca386@mail.gmail.com> <20091027140558.GA17208@suse.de> <4AE8E953.6090504@canonical.com> <20091029010419.GA18410@suse.de> <4AE8EBCB.5030102@canonical.com> <20091029011759.GA908@suse.de> <4AE8EF8C.9030805@canonical.com> <20091029012857.GA30274@suse.de> <4AE8F604.2090005@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE8F604.2090005@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>>> But now, it is hard for us to do that without a workable Android 
>>> drivers in mainline.
>>
>> Then push on Google to get them cleaned up and fixed!  Or do it
>> yourself, all I need is a developer to take ownership of the code.
>>
>
> I'm doing a task which is trying to merge Android patches to Ubuntu 
> kernel and mainline, not only the Android drivers but also the ARM port 
> code which is not in mainline.
>
> But since Android kernel is 2.6.29 and ours or mainline is 2.6.31+, you 
> know it needs much more effort without Google's help.
>
> And for sure, I'm very happy to help this out.

I guess Greg will be happy to put android stuff back into staging if
you promise to maintain it. That should be fairly low effort (hour per
week?). Basically you have to respond to email, fix it when it breaks,
and perhaps test compile it when -rc1 comes...

Sounds easy enough, no?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
