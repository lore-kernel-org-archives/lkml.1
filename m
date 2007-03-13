Return-Path: <linux-kernel-owner+w=401wt.eu-S1030763AbXCMQXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030763AbXCMQXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030765AbXCMQXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:23:09 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:4440 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030763AbXCMQXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:23:08 -0400
Message-ID: <45F6CFEA.4060009@rtr.ca>
Date: Tue, 13 Mar 2007 12:23:06 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Phil Kaslo <phil@cs.arizona.edu>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Asus P5B-VM motherboard:  cd drive malfunctions if internal nic
 in use.
References: <200703122212.l2CMCaxm032601@osprey.cs.arizona.edu> <45F5D59E.10304@rtr.ca> <20070313153252.GC22466@csclub.uwaterloo.ca>
In-Reply-To: <20070313153252.GC22466@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Mar 12, 2007 at 06:35:10PM -0400, Mark Lord wrote:>

>> Off topic:  do your USB ports power off when the system shuts down?
>> Mine don't -- the +5V continues on them.. I'd love a tip on how to
>> turn them off completely at shutdown.
> 
> Most Asus boards have jumpers for the USB ports to select between +5V
> and +5VSB (stand by power).  The reason to provide standby power is so
> that keyboards with power buttons can remain powered so that you can
> turn the system on using the usb keyboard.  If you want to power off the
> ports entirely, jumper them to the +5V line instead which only has power
> when the system is on.

That's nice.

But the P5B-VM board does not have any such jumper for USB,
nor does it have any obvious combination of BIOS-setup options
to accomplish it.

