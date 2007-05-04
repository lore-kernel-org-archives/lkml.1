Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbXEDWbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbXEDWbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 18:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbXEDWbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 18:31:35 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:57136
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbXEDWbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 18:31:34 -0400
Message-ID: <463BC223.2040304@microgate.com>
Date: Fri, 04 May 2007 17:30:43 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Antonino Ingargiola <tritemio@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible
 bug]
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>	 <5486cca80705040956g47f634ddp80d67038e8e3305a@mail.gmail.com>	 <463B7534.6000207@microgate.com>	 <5486cca80705041013pf481c2an9e639fc9285ba88e@mail.gmail.com>	 <1178299247.3769.0.camel@amdx2.microgate.com>	 <5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>	 <1178300493.3619.1.camel@amdx2.microgate.com>	 <5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>	 <5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>	 <1178308173.3743.14.camel@amdx2.microgate.com> <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
In-Reply-To: <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino Ingargiola wrote:
> "With the patch, flushing the input results effectively in a complete flush.
> However after doing the flush I can't read [further] chars [sent to
> the serial port]
> without closing and reopening the port. I've verified this behavior both
> communicating between two serial ports and both communicating with an
> usb-serial device (driver cdc-acm)."

OK, this behavior is so unexpected I must be missing
something basic. Not being able to reproduce this myself
is a problem. If I think of something I'll post.

--
Paul
