Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbXFJWq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbXFJWq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 18:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759816AbXFJWqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 18:46:17 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.212]:49940 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759626AbXFJWqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 18:46:16 -0400
Message-ID: <466C7F28.3040805@andrew.cmu.edu>
Date: Sun, 10 Jun 2007 18:46:00 -0400
From: James Bruce <bruce@andrew.cmu.edu>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: linux-kernel@vger.kernel.org, Tarkan Erimer <tarkan@netone.net.tr>,
       debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       greg@kroah.com
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr> <20070609071231.GL2649@lug-owl.de>	 <466BB9B0.5030908@netone.net.tr>	 <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>	 <466BCBBC.90305@netone.net.tr>	 <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>	 <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com>	 <466C0901.4000405@netone.net.tr>	 <alpine.LFD.0.98.0706101025330.20321@woody.linux-foundation.org>	 <466C69D8.7030401@andrew.cmu.edu> <9a8748490706101447g54e9ac65yb1c81cf1249849da@mail.gmail.com>
In-Reply-To: <9a8748490706101447g54e9ac65yb1c81cf1249849da@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
>> One thing that would make that easier in the future is if contributers
>> at least started to dual-license their submissions.  I.e. if instead
>> of "GPL version 2", one could say "GPL version 2 or GPL version 3".
>> It isn't the same thing as the problematic "GPL version 2 or later",
>> because the developer is not agreeing to an unseen license (GPLv4,
>> etc).  What it does do is make it easier to move to GPLv3 a few years
>> from now, if that is decided then, as a significant fraction of the
>> code will already be GPLv3 compatible.  That way, if a reason is ever
>> found to move to v3, at least some of the work will already be done.
>>
> Good luck convincing all contributors to do that.

Well, it's something that pro-GPLv3 people can do right now, instead of 
just lobbying/complaining.  Given 1000 developers, if 400 start dual 
licensing now, and down the road some compelling reason for GPLv3 does 
arise (read: a lawsuit with teeth), that's 600 people you need to 
contact/convince to change, not 1000.  This is made more interesting by 
that fact that 40% of the kernel code is already "GPLv2 or later", as 
someone else pointed out.

> Personally I'm happy with GPL v2, and I for one won't be
> dual-licensing anything I contribute until I see a clear benefit of
> doing so (and I don't yet).

Well, all my personal (non-kernel) stuff is still GPLv2 only right now 
(Linus' opinion is what convinced me that "or later" is dumb), and like 
many I disliked the original GPLv3 draft.  I'm willing to wait until the 
final one is out though, and I think my libraries will end up being 
dual-licensed, with contributions required to be dual-licensed.  I want 
to avoid v3 lock-in, but I don't want to cripple v3 projects either.

> In any case, this whole debate is still a bit premature since GPL v3
> has not even arrived in its final form yet.

Agreed.

  - Jim Bruce
