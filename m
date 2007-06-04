Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbXFDPKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbXFDPKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbXFDPKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:10:25 -0400
Received: from neon.samage.net ([85.17.153.66]:59964 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbXFDPKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:10:24 -0400
Message-ID: <2204.81.207.0.53.1180969821.squirrel@secure.samage.net>
In-Reply-To: <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz>
References: <20070604112426.GA2707@elf.ucw.cz>
    <Pine.LNX.4.64.0706041434040.29896@twin.jikos.cz>
    <20070604130903.GC1971@elf.ucw.cz>
    <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz>
Date: Mon, 4 Jun 2007 17:10:21 +0200 (CEST)
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
From: "Indan Zupancic" <indan@nul.nu>
To: "Jiri Kosina" <jikos@jikos.cz>
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>, "Andi Kleen" <ak@suse.de>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 38b42a75504d14ed68437fa295b89bc6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, June 4, 2007 15:12, Jiri Kosina wrote:
> Are you sure that it's this dummy blink driver that makes the kernel
> stuck? I can't see how it could be causing any hogs - see commit f038f9.

To make it clear, I'm not using the blink driver and get the stuck
key problem too. (And also a warpy PS/2 mouse.)

Wildly guessing: As the problem doesn't seem to be widespread,
perhaps it's suspend to ram related. I'll try running a while without
suspending and see if it crops up too then.

Greetings,

Indan


