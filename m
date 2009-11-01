Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbZKAQlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbZKAQlI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 11:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZKAQlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 11:41:06 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44951 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbZKAQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 11:41:05 -0500
Message-ID: <4AEDBA10.5050607@canonical.com>
Date: Mon, 02 Nov 2009 00:40:48 +0800
From: Bryan Wu <bryan.wu@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Greg KH <gregkh@suse.de>
CC: Brian Swetland <swetland@google.com>, Eric Miao <eric.miao@canonical.com>,
       kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Android logger: fix compiling error
References: <1256316741-14053-1-git-send-email-bryan.wu@canonical.com> <f17812d70910262140i63e4d2f0x708521a9287ca386@mail.gmail.com> <20091027140558.GA17208@suse.de> <4AE8E953.6090504@canonical.com> <20091029010419.GA18410@suse.de> <4AE8EBCB.5030102@canonical.com> <20091029011759.GA908@suse.de> <4AE8EF8C.9030805@canonical.com> <20091029012857.GA30274@suse.de> <4AE8F604.2090005@canonical.com> <20091030140806.GD1481@ucw.cz>
In-Reply-To: <20091030140806.GD1481@ucw.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>>> But now, it is hard for us to do that without a workable Android 
>>>> drivers in mainline.
>>> Then push on Google to get them cleaned up and fixed!  Or do it
>>> yourself, all I need is a developer to take ownership of the code.
>>>
>> I'm doing a task which is trying to merge Android patches to Ubuntu 
>> kernel and mainline, not only the Android drivers but also the ARM port 
>> code which is not in mainline.
>>
>> But since Android kernel is 2.6.29 and ours or mainline is 2.6.31+, you 
>> know it needs much more effort without Google's help.
>>
>> And for sure, I'm very happy to help this out.
> 
> I guess Greg will be happy to put android stuff back into staging if
> you promise to maintain it. That should be fairly low effort (hour per
> week?). Basically you have to respond to email, fix it when it breaks,
> and perhaps test compile it when -rc1 comes...
> 
> Sounds easy enough, no?
> 									Pavel

Great, I do love to maintain it with the help from Brian Swetland and other 
Google folks.

Thanks a lot, Greg and Pavel.

-Bryan
