Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYJ1AVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYJ1AVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYJ1AV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:21:29 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:49527 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbYJ1AV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:21:28 -0400
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2008 20:21:28 EDT
Message-ID: <49064D56.9070405@gmail.com>
Date: Tue, 28 Oct 2008 02:23:02 +0300
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mike Lothian <mike@fireburn.co.uk>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: Reiser4 and d_alloc_anon
References: <f3f71ab90810260724i4db015d8r2eb562d9ef142fe1@mail.gmail.com>
In-Reply-To: <f3f71ab90810260724i4db015d8r2eb562d9ef142fe1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Lothian wrote:
> Hi
>
> Reiser4 still uses d_alloc_anon and is't compiling on Linus's tree
>
> I took a look at:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=440037287c5ebb07033ab927ca16bb68c291d309
>
> But it looks like it isn't a case of renaming to d_obtain_alias
>
> Does any one have a patch for this?
>
>   

Does the last -mm work properly btw?
I didn't take a look at this yet, but it shouldn't be a big deal..

Thanks,
Edward.
