Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab0BDODb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:03:31 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:21265 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932248Ab0BDOD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:03:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0BAKRiaktLd/sX/2dsb2JhbAAIgyvDXpAHgS6CQ1oE
X-IronPort-AV: E=Sophos;i="4.49,404,1262581200"; 
   d="scan'208";a="55306217"
Message-ID: <4B6AD3AF.5010501@teksavvy.com>
Date: Thu, 04 Feb 2010 09:03:27 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 02/10] drivers/ata: Fix continuation line formats
References: <cover.1265095093.git.joe@perches.com>	<12d39ac4f14bfe82a02b4ee246d183b48988fe12.1265095094.git.joe@perches.com>	<4B69B0A0.2040701@teksavvy.com>	<1265224535.24887.16.camel@Joe-Laptop.home>	<4B6A5443.6090804@teksavvy.com> <20100203211331.81d9bb69.akpm@linux-foundation.org>
In-Reply-To: <20100203211331.81d9bb69.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 03 Feb 2010 23:59:47 -0500 Mark Lord <kernel@teksavvy.com> wrote:
>> Joe Perches wrote:
>>> If it's ever agreed that all lines > 80 cols are OK or
>>> new args after column 80 are OK, then sure.  Until then,
>>> if you want it, you should do it.
>> ..
>>
>> You are the code nanny trying to get this patch in.  Not me.
>>
> 
> It's a runtime bug.  Are "code nannies" supposed to "try" to fix
> runtime bugs in libata while others just sit there and insult them?
..

Oh, there's a service affecting bug there?
Well, I guess that means we should accept a shoddy patch, then.  :)

But seriously, I didn't mean anything bad by it, just that
it ought to be simple for the original sender to just reformat it
and resubmit.  Just like everyone else here does on a daily basis.

No point in making the code harder to read/understand for no good reason.

But if these patches are robot generated (by a code scan tool or something),
then the original sender (Joe) might have many others in the queue
throughout the kernel, which could explain the reluctance here.

Really, though the best solution would be for Jeff to just edit
that one line as he integrates the patch, like Linus would do.
I imagine Jeff's already done that by now.  ;)

Cheers
