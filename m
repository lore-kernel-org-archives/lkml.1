Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbYJSBwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbYJSBwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 21:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYJSBv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 21:51:57 -0400
Received: from mail.lang.hm ([64.81.33.126]:36786 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYJSBv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 21:51:57 -0400
Date: Sat, 18 Oct 2008 18:52:29 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jan Engelhardt <jengelh@medozas.de>
cc: Thorsten Leemhuis <thl@ct.heise.de>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <alpine.LNX.1.10.0810181743420.27947@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.DEB.1.10.0810181850340.11267@asgard.lang.hm>
References: <20081016002509.GA25868@kroah.com> <48F6E6EF.8020701@ct.heise.de> <alpine.DEB.1.10.0810160032550.3905@asgard.lang.hm> <alpine.LNX.1.10.0810181743420.27947@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008, Jan Engelhardt wrote:

> On Thursday 2008-10-16 03:34, david@lang.hm wrote:
>> On Thu, 16 Oct 2008, Thorsten Leemhuis wrote:
>>> On 16.10.2008 02:25, Greg KH wrote:
>>>
>>> Hence people that write a lot of articles about things that happen in linux
>>> land (like LWN.net or I do) would be forced to write sentences like "[...]the
>>> kernel that will become 2008.3 or 2009.0 will have feature foo that works
>>> like this[...]". That will get really confusing if you read those articles
>>> half a year later -- especially if that kernel became 2008.3 in the end,
>>> because foo in 2009.0 might already look quite different again...
>>
>> pick a name when the merge window opens
>
> Hell no, we're not a distro.

huh?

we are picking the name for the next kernel far more in advance today (we 
know that the next kernel will be named 2.6.28, and the one after thta 
2.6.29)

I'm just saying, pick the name/number for the kernel based on when the 
merge window opened.

if it's the first merge window in 2009 the kernel would be 2009.1.0, if 
it's the 5th merge window it would be 2009.5.0, even if the resulting 
kernel ended up getting released in 2010

David Lang
