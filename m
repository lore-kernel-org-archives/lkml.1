Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbYJRHTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbYJRHTy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 03:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJRHTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 03:19:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34040 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYJRHTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 03:19:45 -0400
Message-ID: <48F98DE2.8030205@kernel.org>
Date: Sat, 18 Oct 2008 00:18:58 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016153053.GJ5834@nostromo.devel.redhat.com> <20081016154726.GA6331@kroah.com> <20081016171626.GB22554@cs181140183.pp.htv.fi> <20081017040239.GB28188@kroah.com> <20081017103138.1ca68d17@lxorguk.ukuu.org.uk> <48F8C000.8030003@kernel.org> <20081017174226.GF2221@kroah.com>
In-Reply-To: <20081017174226.GF2221@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>>
>> I think it's both visually cumbersome and has the problem that it is harder 
>> to predict future releases.  The first problem can be dealt with by simply 
>> subtracting 2000 from the year (Altera uses this scheme for their EDA 
>> tools, and I didn't realize it for quite a while because it looked so 
>> natural), but the second is still a problem.
> 
> What is the "problem" of predicting future releases?  What relies on the
> actual number being "correct" some random time in the future?
> 

We already have the 2.6.28-rc series; and we are already talking about 
2.6.29 features.

We *really* don't want 2008.3-rc4 to be followed by 2009.1-rc5.  That is 
the kind of stuff that make script makers want to strangle developers 
alive with their own intestines.

	-hpa
