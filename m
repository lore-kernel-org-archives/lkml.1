Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbXFOPKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbXFOPKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXFOPKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:10:38 -0400
Received: from mx.laposte.net ([81.255.54.16]:57589 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXFOPKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:10:37 -0400
Message-ID: <1078.192.54.193.51.1181908112.squirrel@rousalka.dyndns.org>
Date: Fri, 15 Jun 2007 13:48:32 +0200 (CEST)
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
To: "Daniel Hazelton" <dhazelton@enter.net>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc7
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Re-sending with the right subject]

>> > by your argument, the user has some "right to modify the
software", on
>> > that piece of hardware it bought which had free software on it,
correct?
>>
>> Yes.  This means the hardware distributor who put the software in
there must not place roadblocks that impede the user to get where
she wants with the software, not that the vendor must offer the
user a sport car to take her there.

>Okay. That means that if I ship Linux on a ROM chip I have to somehow
make
>it so that the person purchasing the chip can modify the copy of
Linux installed on the chip *if* I want to follow both the spirit and
the
letter
>of the GPLv2.

The key word there is "can"

You don't have to send the buyer the hardware design, replace the ROM
with a flash, use a rom socket that allows easy switching etc.

But you can not add measures to your hardware specifically designed to
stop the user from modifying the GPL software part. Especially if
those measures are something like DRM that do not make the tinkering
just technically hard, but legally forbidden.

As long as the restrictions result from technical choices not
targetted at forbidding changes you're ok.

However if the restrictions are deliberately added, have a legal
component (and legal is not "may" but absolute "can not"), that's
another thing entirely.

To take a simple example people will understand:
- everywhere around the world judges can order newspapers to publish
corrections after a slander trial
- these corrections take different forms depending on the media: in
the original article for on-line stuff, in new editions for printed
stuff

So the fact there is a legal obligation to allow judges to change
articles does not imply newspapers are forced to forgo read-only paper
prints. However editors can not refuse to change the online edition
because they have the technical possibility to do so.

"Software" change oblications (articles) are not dictating "hardware"
(read-only paper prints)

Now do anyone has a doubt how a judge would react if the newspaper
told him it wouldn't change the online edition because it's protected
by a DRM-like lock the newspaper does not want to change or share? DRM
is not a technical limitation like paper print, it's a self-imposed
artificial limitation.

-- 
Nicolas Mailhot

