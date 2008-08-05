Return-Path: <linux-kernel-owner+w=401wt.eu-S1762857AbYHERZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762857AbYHERZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760573AbYHERZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:25:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58843 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822AbYHERZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:25:06 -0400
Message-Id: <200808051724.m75HOKRM023618@terminus.zytor.com>
MIME-Version: 1.0
content-class: 
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: x86 BIOS interface for partitioning and system serial number
 on SGI UV
Date: Tue, 5 Aug 2008 10:24:42 -0700
Importance: normal
X-Priority: 3
To: Mike Travis <travis@sgi.com>
CC: Kyle Moffett <kyle@moffetthome.net>, Russ Anderson <rja@sgi.com>,
       <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For code that is ready you should of course have a reasonable expectation that the code should go in in a timely manner.  Anything other than that would be blatantly unfair.  What I have reacted to is (a) the pushing of code which is obviously not even complete, and (b) demanding that *other* people prioritize you particular problems.  Both of these are blatantly abusive.

-- 
Sent from my mobile phone (pardon any lack of formatting)


-----Original Message-----
From: Mike Travis <travis@sgi.com>
Sent: Tuesday, August 05, 2008 8:56
To: H. Peter Anvin <hpa@zytor.com>
Cc: Kyle Moffett <kyle@moffetthome.net>; Russ Anderson <rja@sgi.com>; mingo@elte.hu; tglx@linutronix.de; linux-kernel@vger.kernel.org; Jack Steiner <steiner@sgi.com>
Subject: Re: x86 BIOS interface for partitioning and system serial number on SGI UV

H. Peter Anvin wrote:
> Mike Travis wrote:
>>
>> Hi Kyle,
>>
>> As I'm very new to this development arena, could you explain a bit more
>> on why this is considered "bad manners"?
>>
>> I'm not speaking of any particular change, but there are some
>> realities in
>> bringing a new product to market that depends heavily on new "features"
>> being accepted into a specific kernel release.  I certainly do not want
>> to "taint" any kernel code (and I'm always amazed at the dedication of
>> so many individuals to insure this doesn't happen), but the line between
>> acceptability (and not) seems to waver all over the place... ;-)
>>
> 
> It's because it's your responsibility to get the code in by whenever you
> need it to, but trying to push unfinished code with the motivation "we
> need it in by <release>" violates the development model *and* is just
> plain rude.
> 
> This comes down to the old saying "lack of planning on your part does
> not constitute an emergency on my part."
> 
> In other words, if you want to push code in by a specific release, the
> code needs to be *done* and properly submitted.  Submitting code that
> has a big "real code goes here" comment, is ridiculous.
> 
> Unfortunately we have seen a *lot* of that from several people at SGI
> over the last year.
> 
>     -hpa

Hi Peter,

Ok, thanks, I do see your point (very clearly), as I prepare yet another
"we really, really need this" patch... ;-)

[ok, it's only a led driver and the world won't stop if it doesn't show up
in the kernel... ;-)]

Cheers,
Mike

