Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbYJSCoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbYJSCoy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 22:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYJSCop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 22:44:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:40807 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbYJSCop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 22:44:45 -0400
Date: Sat, 18 Oct 2008 22:44:42 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: david@lang.hm
cc: Thorsten Leemhuis <thl@ct.heise.de>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <alpine.DEB.1.10.0810181850340.11267@asgard.lang.hm>
Message-ID: <alpine.LNX.1.10.0810182243460.23218@fbirervta.pbzchgretzou.qr>
References: <20081016002509.GA25868@kroah.com> <48F6E6EF.8020701@ct.heise.de> <alpine.DEB.1.10.0810160032550.3905@asgard.lang.hm> <alpine.LNX.1.10.0810181743420.27947@fbirervta.pbzchgretzou.qr> <alpine.DEB.1.10.0810181850340.11267@asgard.lang.hm>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-10-18 21:52, david@lang.hm wrote:
>> >
>> > pick a name when the merge window opens
>>
>> Hell no, we're not a distro.
>
> huh?
>
> we are picking the name for the next kernel far more in advance today (we know
> that the next kernel will be named 2.6.28, and the one after thta 2.6.29)

"name" is not the same as "version". When you say name, I get this:

	$ grep NAME Makefile 
	NAME = Rotary Wombat

and we, hey, we already have names!

> I'm just saying, pick the name/number for the kernel based on when the merge
> window opened.

Yeah. I mean that's how it was done so far :)
