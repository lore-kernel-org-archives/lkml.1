Return-Path: <linux-kernel-owner+w=401wt.eu-S1423201AbXBUWZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423201AbXBUWZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423202AbXBUWZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:25:42 -0500
Received: from sycorax.lbl.gov ([128.3.11.121]:1531 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423201AbXBUWZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:25:41 -0500
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Feb 2007 17:25:41 EST
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
References: <20070219044616.GC25659@washoe.onerussian.com>
	<20070219000412.acad13de.akpm@linux-foundation.org>
	<1171876788.6046.3.camel@localhost.localdomain>
Date: Wed, 21 Feb 2007 14:18:13 -0800
In-Reply-To: <1171876788.6046.3.camel@localhost.localdomain> (message from
	Richard Purdie on Mon, 19 Feb 2007 09:19:48 +0000)
Message-ID: <877iub9mu2.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie <rpurdie@rpsys.net> writes:

> On Mon, 2007-02-19 at 00:04 -0800, Andrew Morton wrote:
>> On Sun, 18 Feb 2007 23:46:16 -0500 Yaroslav Halchenko <kernel@onerussian.com> wrote:
>> > Since the most recent successful for me kernel 2.6.19-rc6-mm1, I've
>> > tried few times to build more recent snapshots and now finally
>> > 2.6.20-mm2. In all those cases I have a sad outcome -- kernel boots but
>> > at some point during boot (few moments after Penguin icon in the top left
>> > corner appears), light turns off... I still can see something, especially
>> > if I light a strong flashlight at a sharp angle.
>> > 
>> > I've enabled back-light support and lcd support for those unsuccessful
>> > kernels (with all backlight support features disabled kernel boots
>> > ok and backlight shines as bright as always)
>>
>> Is 2.6.20 broken?  I assume the latest 2.6.20-gitN snapshot are failing..
>
> It would be extremely useful to know which kernel versions you tested
> and which ones failed. There are a number of backlight changes which are
> just in 2.6.20-mm1 and -mm2 which it would be useful to rule out or
> identify as the cause.

i have exactly the same problem with 2.6.21-rc1 on a thinkpad t40
with an ati radeon card. the machine boots up but the backlight never
comes on. 2.6.20 worked okay.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
