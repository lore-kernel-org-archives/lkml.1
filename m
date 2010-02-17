Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab0BQNIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:08:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:34864 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab0BQNIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:08:20 -0500
Message-ID: <4B7BEA41.6080303@suse.cz>
Date: Wed, 17 Feb 2010 14:08:17 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Hui Zhu <teawater@gmail.com>
Cc: Hui Zhu <hui.zhu@windriver.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] markup_oops.pl: add options to improve cross-sompilation
 	environments
References: <4B5E5D4F.50803@windriver.com> <2375c9f91001251905p6ed99405m3915ac56e230605f@mail.gmail.com> 	<4B5E9BE9.2030702@windriver.com> <2375c9f91001252353u52f437b0t7ddd643a57047e1c@mail.gmail.com> 	<4B5EB223.60307@windriver.com> <4B6344CA.10504@suse.cz> <4B666982.1020007@windriver.com> 	<4B6C8FF0.3090106@suse.cz> <daef60381002071855m7a5d6d2cg7b9a9a48b6aef20e@mail.gmail.com>
In-Reply-To: <daef60381002071855m7a5d6d2cg7b9a9a48b6aef20e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.2.2010 03:55, Hui Zhu wrote:
> Hi Michael,
> 
> Looks you miss this one:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ef2b9b054580ef835078d8aa411bd06542cd5c1c


That one is already in Linus' tree, so this is OK. BTW please don't
top-post.

Michal

> On Sat, Feb 6, 2010 at 05:38, Michal Marek <mmarek@suse.cz> wrote:
>> Thanks, I applied the previous and this patch. Just to make sure I
>> didn't miss any of your patches, can you check that
>> http://repo.or.cz/w/linux-kbuild.git/blob/refs/heads/for-next:/scripts/markup_oops.pl
>> has all your changes? If something is missing, please resend it, thanks.
