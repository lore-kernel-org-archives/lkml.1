Return-Path: <linux-kernel-owner+w=401wt.eu-S932901AbXCRTlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbXCRTlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933036AbXCRTlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:41:11 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:33494 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020AbXCRTlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:41:10 -0400
Date: Sun, 18 Mar 2007 13:41:01 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 1000xf bus problem
In-reply-to: <fa.wDPF1lWlqGQpxbyWee64Z3t4BVM@ifi.uio.no>
To: Greg.Chandler@wellsfargo.com, linux-kernel <linux-kernel@vger.kernel.org>
Cc: e1000-devel@lists.sourceforge.net
Message-id: <45FD95CD.2030403@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.wDPF1lWlqGQpxbyWee64Z3t4BVM@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg.Chandler@wellsfargo.com wrote:
> I'm running a e1000xf adapter in a 64-bit/100Mhz PCI slot.  The intel
> site shows this is a supported config for the card, but linux is pulling
> this info:
> 
> ed:02.0 Ethernet controller: Intel Corporation 82544EI Gigabit Ethernet
> Controller (Fiber) (rev 02)
> 	Subsystem: Intel Corporation PRO/1000 XF Server Adapter
> 	Flags: bus master, 66Mhz, medium devsel, latency 64, IRQ 18
> 	Memory at f7fe0000 (64-bit, non-prefetchable) [size=128K]
>       Memory at f7fc0000 (64-bit, non-prefetchable) [size=128K]
>       I/O ports at 7000 [size=32]
>       [virtual] Expansion ROM at f10a0000 [disabled] [size=128K]
>       Capabilities: [dc] Power Management version 2
>       Capabilities: [e4] PCI-X non-bridge device
>       Capabilities: [f0] Message Signalled Interrupts: 64bit+ Queue=0/0
> Enable-
> 
> My thoughput tests show it is definitely not running at the 100Mhz bus
> rate is should be capable of.

How are you determining this?

 > Any ideas on how to make it work at full speed?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

