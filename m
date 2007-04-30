Return-Path: <linux-kernel-owner+w=401wt.eu-S1423072AbXD3G0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423072AbXD3G0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 02:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423075AbXD3G0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 02:26:42 -0400
Received: from mail.syneticon.net ([213.239.212.131]:33713 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423072AbXD3G0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 02:26:40 -0400
Message-ID: <46358BCB.3040303@wpkg.org>
Date: Mon, 30 Apr 2007 08:25:15 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.21
References: <4635084A.6010506@wpkg.org> <20070430030213.GB23336@stusta.de>
In-Reply-To: <20070430030213.GB23336@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk schrieb:
> On Sun, Apr 29, 2007 at 11:04:10PM +0200, Tomasz Chmielewski wrote:
>> Linus Torvalds wrote:
>>
>>> On Sun, 29 Apr 2007, Adrian Bunk wrote:
>>>> The kernel Bugzilla currently contains 1600 open bugs.
>>> Adrian, why do you keep harping on this, and ignoring reality?
>>> Kernel bugzilla has 1600 open bugs BECAUSE IT SUCKS.
>>> How many of those are interesting and valid? How many of them are 
>>> relevant? How many of them are duplicates?
>> And - how many of these bug reports have kernel's bugzilla ever forwarded 
>> to lkml so that other people could see them?
>>
>> Is that number zero (because kernel's bugzilla is configured this way)?
> 
> Andrew forwards incoming Bugzilla bugs to the responsible maintainers 
> (if there are any).
> 
> If it is considered useful it shouldn't be a problem to automatically 
> forward all incoming Bugzilla bugs to linux-kernel.

Why isn't it done yet? If the bugs were already forwarded to 
linux-kernel (and perhaps, to linux-<subsystem> when possible, too), we 
would save at least two days of this long "Linux 2.6.21" thread...

For I somehow feel that most people here dislike bugzilla because of 
misconceptions - which only arose as bugzilla.kernel.org is *really* 
misconfigured.


-- 
Tomasz Chmielewski
http://wpkg.org
