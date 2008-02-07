Return-Path: <linux-kernel-owner+w=401wt.eu-S1760398AbYBGQbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398AbYBGQbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbYBGQbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:31:12 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34939 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYBGQbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:31:10 -0500
Message-ID: <47AB324C.5070002@davidnewall.com>
Date: Fri, 08 Feb 2008 03:01:08 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Adrian Bunk <bunk@kernel.org>, Chris Friesen <cfriesen@nortel.com>,
       Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	<20080202123710.42df1aa0@weinigel.se>	<20080202191930.GA19826@kroah.com>	<20080203124849.0226560f@weinigel.se>	<84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com>	<47A5F418.6030104@weinigel.se>	<20080203231530.GB15692@kroah.com>	<courier.47A8EDDC.0000785F@hawking.rebel.net.au>	<47A8F27F.3060504@nortel.com>	<20080206210452.GB7198@cs181133002.pp.htv.fi>	<47AB06F9.30201@davidnewall.com>	<20080207141557.5fcf3b2d@core>	<47AB1D91.6090609@davidnewall.com> <20080207150720.2ac6d2c4@core>
In-Reply-To: <20080207150720.2ac6d2c4@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> previous statements which seemed to say, "you've spoken to numerous
>>     
>
> Please don't use "seemed to say" and then quote words I've never said.
> That's misleading, rude and also awful language style.

No, it's called, "paraphrasing," and it's quite normal in a
conversation.  You say something, I tell you what I think you said, you
refine your language, and the process continues until we're happy that a
semantic consensus has been reached.  In that spirit, should I now
understand that what you meant is that *you* *think* that kernel modules
must be released under GPL.  Should I accept that you didn't mean that
numerous lawyers had told you that this was factually so?

Of course, this begs the question of why there would be a
MODULE_LICENSE("proprietary").  You may hold beliefs as understood
above, but it seems guaranteed that the opinions of those who count are
divided.
