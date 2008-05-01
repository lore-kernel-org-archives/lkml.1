Return-Path: <linux-kernel-owner+w=401wt.eu-S1764989AbYEAAMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764989AbYEAAMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYEAAMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:12:41 -0400
Received: from mail.lang.hm ([64.81.33.126]:49611 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYEAAMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:12:40 -0400
Date: Wed, 30 Apr 2008 17:14:49 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Chris Shoemaker <c.shoemaker@cox.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <20080501000131.GB1559@pe.Belkin>
Message-ID: <alpine.DEB.1.10.0804301713040.7807@asgard>
References: <20080429.190352.137408408.davem@davemloft.net> <200805010023.32213.rjw@sisk.pl> <alpine.DEB.1.10.0804301528250.7807@asgard> <200805010145.39373.rjw@sisk.pl> <alpine.DEB.1.10.0804301654200.7807@asgard> <20080501000131.GB1559@pe.Belkin>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008, Chris Shoemaker wrote:

> On Wed, Apr 30, 2008 at 04:57:38PM -0700, david@lang.hm wrote:
>>>> history has shown that developers do not stop developing if their patches are
>>>> not accepted, they just fork and go their own way.
>>>
>>> That's mostly when they feel that they are treated unfairly.
>>>
>>> OTOH, insisting that your patches should be merged at the same rate that you're
>>> able to develop them is unreasonable to me.
>>
>> it's not nessasarily the individuals that fork, it's the distros who want
>> to include the fixes and other changes that the individuals that create the
>> fork.
>
> Is that really bad?  Isn't that effectively equivalent to "increased testing of
> earlier intergrations"?

not if there are so many changes that the testing isn't really relavent to 
mainline.

not if the changes don't get into mainline.

look at the mess of the distro kernels in the 2.5 and earlier days. having 
them maintain a large body of patches didn't work for them or for the 
mainline kernel.

David Lang
