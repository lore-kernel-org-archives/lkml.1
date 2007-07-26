Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbXGZEOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbXGZEOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 00:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbXGZENw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 00:13:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43833 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbXGZENw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 00:13:52 -0400
Message-ID: <46A81F67.1040502@garzik.org>
Date: Thu, 26 Jul 2007 00:13:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Satyam Sharma <satyam.sharma@gmail.com>,
       Rene Herman <rene.herman@gmail.com>, Jos Poortvliet <jos@mijnkamer.nl>,
       david@lang.hm, Nick Piggin <nickpiggin@yahoo.com.au>,
       Valdis.Kletnieks@vt.edu, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org,
       Paul Jackson <pj@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
References: <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm> <a781481a0707251033t5b95cde7k620810bcc0b98c1@mail.gmail.com> <20070725203523.GA10750@elte.hu> <200707260432.52739.bzolnier@gmail.com>
In-Reply-To: <200707260432.52739.bzolnier@gmail.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 25 July 2007, Ingo Molnar wrote:
>> you dont _have to_ cooperative with the maintainer, but it's certainly 
>> useful to work with good maintainers, if your goal is to improve Linux. 
>> Or if for some reason communication is not working out fine then grow 
>> into the job and replace the maintainer by doing a better job.
> 
> The idea of growing into the job and replacing the maintainer by proving
> the you are doing better job was viable few years ago but may not be
> feasible today.

IMO...  Tejun is an excellent counter-example.  He showed up as an 
independent developer, put a bunch of his own spare time and energy into 
the codebase, and is probably libata's main engineer (in terms of code 
output) today.  If I get hit by a bus tomorrow, I think the Linux 
community would be quite happy with him as the libata maintainer.


> The another problem is that sometimes it seems that independent developers
> has to go through more hops than entreprise ones and it is really frustrating
> experience for them.  There is no conspiracy here - it is only the natural
> mechanism of trusting more in the code of people who you are working with more.

I think Tejun is a counter-example here too :)  Everyone's experience is 
different, but from my perspective, Tejun "appeared out of nowhere" 
producing good code, and so, it got merged rapidly.

Personally, for merging code, I tend to trust people who are most in 
tune with "the Linux Way(tm)."  It is hard to quantify, but quite often, 
independent developers "get it" when enterprise developers do not.


> Now could I ask people to stop all this -ck threads and give the developers
> involved in the recent events some time to calmly rethink the whole case.

Indeed...

	Jeff


