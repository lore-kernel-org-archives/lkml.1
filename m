Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbXIYFdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbXIYFdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 01:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbXIYFcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 01:32:52 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31237 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbXIYFcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 01:32:51 -0400
Message-ID: <46F89D25.2090301@oracle.com>
Date: Mon, 24 Sep 2007 22:31:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       akpm@linux-foundation.org, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
References: <20070924111318.f16cde07.randy.dunlap@oracle.com> <20070924181931.GA3810@infradead.org> <46F800A7.7090005@oracle.com> <20070924183042.GA4418@infradead.org> <46F806AB.1050509@oracle.com> <20070924185431.GA5618@infradead.org> <46F80863.2090102@oracle.com> <20070924133730.c9b7c0e6.randy.dunlap@oracle.com> <20070924210830.GA8554@Krystal> <20070924141258.d413abdd.randy.dunlap@oracle.com> <20070925041003.GA28937@Krystal>
In-Reply-To: <20070925041003.GA28937@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
>> On Mon, 24 Sep 2007 17:08:30 -0400 Mathieu Desnoyers wrote:
>>
>>> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
>>>> On Mon, 24 Sep 2007 11:56:35 -0700 Randy Dunlap wrote:
>>>>
>>>>> Christoph Hellwig wrote:
>>>>>> On Mon, Sep 24, 2007 at 11:49:15AM -0700, Randy Dunlap wrote:
>>>>>>> I think that samples are perfectly fine for documentation and
>>>>>>> that the trace example is a good example.  I think that most people
>>>>>>> who need something like that would need to customize it for their
>>>>>>> specific needs anyway.
>>>>>>>
>>>>>>> We don't seem to be making progress...
>>>>>> Time to bring in a Tie-Breaker :)
>>>>> Yes.  Is anyone else interested?   :(
>>>>
>>>> I guess that's everyone (except those who are sleeping).
>>>>
>>>> Let's not hold up progress.  Just use samples/ for code.
>>> Would you already have the 
>>>
>>> Makefile
>>> samples/Kconfig
>>> samples/Makefile
>>>
>>> core code handy per chance ? (and probably Kconfig sourcing in every
>>> arch ?)
>> Yes.  Here it is.  I'm working on add kprobes to it, but you
>> can go ahead with markers also.
>>
>>
> 
> Hi Randy,
> 
> I got everything working and I'm thinking about posting all this stuff
> soon. Do you think your patch (having renamed Kbuild to Makefile) is
> ready to post ?

Yes, AFAIK it is.  Do you want me to resend it or do you want to
make it patch M/N in your patches?

-- 
~Randy
Phaedrus says that Quality is about caring.
