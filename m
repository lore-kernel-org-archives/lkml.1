Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbXFSOFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbXFSOFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXFSOFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:05:44 -0400
Received: from rtr.ca ([64.26.128.89]:3568 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbXFSOFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:05:43 -0400
Message-ID: <4677E2B5.5030503@rtr.ca>
Date: Tue, 19 Jun 2007 10:05:41 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
References: <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com> <20070615110326.b0762b7a.randy.dunlap@oracle.com> <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr> <20070615191804.GC8151@cvg> <4672E6B3.1080205@intel.com> <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr> <20070615194140.GE8151@cvg> <Pine.LNX.4.64.0706152210150.32724@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.98.0706151335240.14121@woody.linux-foundation.org> <Pine.LNX.4.64.0706160833220.32724@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.98.0706160840290.14121@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706160840290.14121@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>
> For example, if I get a patch for something that is a whole driver, I 
> generally think that while I *prefer* to see it follow the kernel coding 
> style, I also expect that the person who sends me the driver is the one 
> who is going to maintain it in the future, and thus his personal coding 
> style preferences will override any but the strongest objections.

As with most things Linux, it would be really nice if more people
here acted like our fearless Penguin leader.

But the reality is that perfectly good code is frequently rejected
(for rework) due to 81-character lines and even more trivial stylistic
differences, even (especially) in entirely new driver sources.
