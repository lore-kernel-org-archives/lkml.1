Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZAICLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZAICLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 21:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbZAICLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 21:11:23 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:48228 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbZAICLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 21:11:22 -0500
Message-ID: <4966B24E.1050700@lougher.demon.co.uk>
Date: Fri, 09 Jan 2009 02:11:26 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk>	<20090108165029.GA10951@infradead.org> <20090108175338.2abbee16.akpm@linux-foundation.org>
In-Reply-To: <20090108175338.2abbee16.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 8 Jan 2009 11:50:29 -0500 Christoph Hellwig <hch@infradead.org> wrote:
> 
>> On Thu, Jan 08, 2009 at 04:48:51PM +0000, Phillip Lougher wrote:
>>> Please consider pulling my linux-next branch
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git
>>>
>>> The patches have been posted to LKML and linux-fsdevel over the last
>>> couple of months and have been reviewed and changed as requested.
>>> Diffstat below.
>>>
>>> Squashfs is a compressed read-only filesystem. It compresses metadata
>>> and data, and uses up to 1 MiB block sizes for greater compression.
>> That seems pretty fast for something only posted this week and not
>> even in -next.
> 
> I discussed this with Phillip a bit, and it looks like we'll go for a
> 2.6.21 merge.  This gives a couple of months for testing and review in
> linux-next.
> 
> Of course, this assumes that someone will actually perform that testing
> and review.  Chances are that it'll just sit there, getting nothing more
> than compilation testing.

Yes please review!  If people feels it needs a couple more months in
linux-next with more in-depth review then I'll live with that.  I'll
fix anything more that comes up, because I'm desperate to get it
mainlined.  I've lived the last couple of years with constant
moaning from people that I've not mainlined it, and I took
the last six months off work to work on it full time to get
it into shape to mainline.

Hopefully now it's at least in sufficient shape to go into
Linux-next I can get another job, and get some income which
will be nice.

> 
> Apparently I reviewed the code a while back - that grey cell must have
> died.  Does anyone else intend to review the code in that timeframe? 
> If not, we might as well merge it now, if ever..
> 

I'll be very happy for a merge now, but of course it's not up to me :-(

Phillip

> 

