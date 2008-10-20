Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbYJTS4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbYJTS4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYJTSzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:55:52 -0400
Received: from bytemail.bytemark.co.uk ([80.68.81.165]:53677 "EHLO
	bytemail.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbYJTSzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:55:51 -0400
Message-ID: <48FCD421.2010208@bytemark.co.uk>
Date: Mon, 20 Oct 2008 19:55:29 +0100
From: Alex Howells <alex@bytemark.co.uk>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
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
> Not that I care one way or the other.  It's just that I don't see how
> your response bears any relationship with the point Greg made.  It's
> just a distraction.  We're talking about how to label releases, not
> about guessing the release date of a kernel months ahead.  One you
> label it, it stays that way.

Greg,

I do agree with you that kernel numbering is becoming increasingly 
cumbersome now the numbers are becoming larger, and a spreadsheet is 
becoming a handy tool for tracking all this release information.

I'm honestly not sold on any of the naming schemes proposed thusfar, but 
since I can't come up with a magic solution, I'll shut up about that!

What I'd love to see any changes integrate would be a simple way to spot 
-stable releases in the version number (ie: 2.6.16, 2.6.27, those 
maintained for a "long" time and hopefully by 2.6.16.50+ quite 'bug 
free') versus the rest of releases sent out on a more regular basis.

I'll immediately concede this is probably of minimal benefit to 
distribution maintainers who're actively following LKML and development 
in general, but there is a big community of folks out there using 
vanilla kernel.org sources for their own needs who, like me, probably 
find it difficult/frustrating to pick a kernel version these days.

Does anyone have a suggestion how that could be accomplished?

Alex
