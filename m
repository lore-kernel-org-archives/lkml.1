Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYADUJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYADUJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbYADUJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:09:27 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:57191 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbYADUJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:09:25 -0500
Date: Fri, 4 Jan 2008 21:09:24 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild update
In-Reply-To: <20080104194328.GA32091@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0801042107430.1253@fbirervta.pbzchgretzou.qr>
References: <20080103213255.GA21811@uranus.ravnborg.org>
 <Pine.LNX.4.64.0801032308400.26693@fbirervta.pbzchgretzou.qr>
 <20080104194328.GA32091@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 4 2008 20:43, Sam Ravnborg wrote:
>On Thu, Jan 03, 2008 at 11:33:44PM +0100, Jan Engelhardt wrote:
>> 
>> On Jan 3 2008 22:32, Sam Ravnborg wrote:
>> >
>> >On top of this I have my personal todo items such as:
>> >- modern ncurses interface for menuconfig (ala tig, htop and others)
>> 
>> Sorry.. your comparison {menuconfig, htop} raises an "incompatible
>> pointer passed" on my side. Please explain :)
>
>htop is a nice ncurses based interface to top.
>
>Try "F2" and see a nice layout for a menu structure remotely
>similar to menuconfig.

I cannot really think how htop F2 would even be CLOSE to menuconfig.
Just that we are talking about the same thing:
	http://jengelh.hopto.org/GFX0/htopf2.png
hell no, menuconfig looks much nicer than that.

>I could mention a few more - this was more to say that there
>exist much beter looking ncurses based tools than menuconfig.

hm, I can only think of mc right now.
