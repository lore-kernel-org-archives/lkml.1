Return-Path: <linux-kernel-owner+w=401wt.eu-S933805AbYD3Urw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbYD3Urw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764245AbYD3UrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:47:07 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:52251 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765375AbYD3UrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:47:05 -0400
Message-ID: <4818DAC4.0@isomerica.net>
Date: Wed, 30 Apr 2008 16:47:00 -0400
From: Dan Noe <dpn@isomerica.net>
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/2008 16:31, Linus Torvalds wrote:
> 
> On Wed, 30 Apr 2008, Andrew Morton wrote:
>> <jumps up and down>
>>
>> There should be nothing in 2.6.x-rc1 which wasn't in 2.6.x-mm1!
> 
> The problem I see with both -mm and linux-next is that they tend to be 
> better at finding the "physical conflict" kind of issues (ie the merge 
> itself fails) than the "code looks ok but doesn't actually work" kind of 
> issue.
> 
> Why?
> 
> The tester base is simply too small.
> 
> Now, if *that* could be improved, that would be wonderful, but I'm not 
> seeing it as very likely.

Perhaps we should be clear and simple about what potential testers 
should be running at any given point in time.  With -mm, linux-next, 
linux-2.6, etc, as a newcomer I find it difficult to know where my 
testing time and energy is best directed.

Is linux-next the right thing to be running at this point?  Is there a 
need for testing in a particular tree (netdev, x86, etc)?

Cheers,
Dan

-- 
                     /--------------- - -  -  -   -   -
                     |  Dan Noe
                     |  http://isomerica.net/~dpn/
