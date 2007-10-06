Return-Path: <linux-kernel-owner+w=401wt.eu-S1764350AbXJFAXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764350AbXJFAXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 20:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbXJFAXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 20:23:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45133 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbXJFAXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 20:23:34 -0400
Date: Sat, 6 Oct 2007 02:23:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
In-Reply-To: <m3myuxxfub.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0710060222570.21791@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
 <m3r6k9xi2d.fsf@maximus.localdomain> <Pine.LNX.4.64.0710060137520.21791@fbirervta.pbzchgretzou.qr>
 <m3myuxxfub.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 6 2007 02:10, Krzysztof Halasa wrote:
>Jan Engelhardt <jengelh@computergmbh.de> writes:
>
>>>I wonder how accurate is it.
>>
>> Since I do not use 512-glyph fonts, I do not know.
>
>Actually I meant "how accurate my remarks are" :-)
>
>Not convinced WRT ASCII color codes, though. ASCII doesn't contain
>codes for changing colors. Perhaps some specific "extended ASCII"?

Start up QBasic, issue
	COLOR 1
=> blue.

Apply said patch, issue
	vt.printk_color=0x01
=> you get what?

So! :)
