Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbYJTF3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbYJTF3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 01:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbYJTF3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 01:29:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49915 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYJTF3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 01:29:24 -0400
Message-ID: <48FC1727.4030403@zytor.com>
Date: Sun, 19 Oct 2008 22:29:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
CC: "H. Peter Anvin" <hpa@kernel.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016002509.GA25868@kroah.com>	<20081016124943.GE23630@cs181140183.pp.htv.fi>	<20081016151748.GA31075@kroah.com>	<20081016153053.GJ5834@nostromo.devel.redhat.com>	<20081016154726.GA6331@kroah.com>	<20081016171626.GB22554@cs181140183.pp.htv.fi>	<20081017040239.GB28188@kroah.com>	<20081017103138.1ca68d17@lxorguk.ukuu.org.uk>	<48F8C000.8030003@kernel.org> <20081017174226.GF2221@kroah.com>	<48F98DE2.8030205@kernel.org> <ortzb89bak.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <ortzb89bak.fsf@oliva.athome.lsd.ic.unicamp.br>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Oliva wrote:
> 
>> We *really* don't want 2008.3-rc4 to be followed by 2009.1-rc5.
>> That is the kind of stuff that make script makers want to strangle
>> developers alive with their own intestines.
> 
> +1
> 
> Not that I care one way or the other.  It's just that I don't see how
> your response bears any relationship with the point Greg made.  It's
> just a distraction.  We're talking about how to label releases, not
> about guessing the release date of a kernel months ahead.  One you
> label it, it stays that way.
> 

Uhm, so what happens when a release starts with an -rc stage intended 
for 2008 release, and then comes out in 2009?  You either have to leave 
it at 2008, which would be confusing (I think this is what M$ did in at 
least one case), or you have to have an in-release-cycle change.

Plus, of course, it makes it hard to talk about future releases.

	-hpa
