Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbYJQQl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbYJQQl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbYJQQlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:41:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbYJQQlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:41:17 -0400
Message-ID: <48F8C000.8030003@kernel.org>
Date: Fri, 17 Oct 2008 09:40:32 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <greg@kroah.com>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016002509.GA25868@kroah.com>	<20081016124943.GE23630@cs181140183.pp.htv.fi>	<20081016151748.GA31075@kroah.com>	<20081016153053.GJ5834@nostromo.devel.redhat.com>	<20081016154726.GA6331@kroah.com>	<20081016171626.GB22554@cs181140183.pp.htv.fi>	<20081017040239.GB28188@kroah.com> <20081017103138.1ca68d17@lxorguk.ukuu.org.uk>
In-Reply-To: <20081017103138.1ca68d17@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> So I proposed an alternative, YEAR.NUMBER.  The year is easy to keep
> 
> Which calendaring system ?

Presumably the Gregorian one, rooted in the Common Era, but that's sort 
of irrelevant.

I think it's both visually cumbersome and has the problem that it is 
harder to predict future releases.  The first problem can be dealt with 
by simply subtracting 2000 from the year (Altera uses this scheme for 
their EDA tools, and I didn't realize it for quite a while because it 
looked so natural), but the second is still a problem.

	-hpa
