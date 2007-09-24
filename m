Return-Path: <linux-kernel-owner+w=401wt.eu-S1761121AbXIXSvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761121AbXIXSvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbXIXSv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:51:28 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53584 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbXIXSv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:51:27 -0400
Message-ID: <46F806AB.1050509@oracle.com>
Date: Mon, 24 Sep 2007 11:49:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
References: <20070924164950.006047409@polymtl.ca> <20070924165428.335030720@polymtl.ca> <20070924175044.GD1608@infradead.org> <20070924105632.009aba7f.randy.dunlap@oracle.com> <20070924180041.GB2435@infradead.org> <20070924111318.f16cde07.randy.dunlap@oracle.com> <20070924181931.GA3810@infradead.org> <46F800A7.7090005@oracle.com> <20070924183042.GA4418@infradead.org>
In-Reply-To: <20070924183042.GA4418@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Sep 24, 2007 at 11:23:35AM -0700, Randy Dunlap wrote:
>> That might be OK for this case, but sometimes it makes sense to have
>> README etc. about how to use the software.  So you would want this
>> in the Documentation/ tree?  That makes it harder on users.
> 
> If it's so complex that we can't describe it in a few dozens lines
> it shouldn't be anywhere but the place it belongs and better have a
> real use and not just be a sample.  And in the trace case I must
> admit that I'd prefer a real use like some simple syscall-trace
> over this hack anyway..

I think that samples are perfectly fine for documentation and
that the trace example is a good example.  I think that most people
who need something like that would need to customize it for their
specific needs anyway.

We don't seem to be making progress...


-- 
~Randy
Phaedrus says that Quality is about caring.
