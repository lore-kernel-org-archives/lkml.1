Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZAXMGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZAXMGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 07:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZAXMGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 07:06:46 -0500
Received: from marvin.heresymail.org ([87.106.62.5]:41204 "EHLO
	marvin.heresymail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZAXMGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 07:06:45 -0500
Message-ID: <497B044D.3000706@walrond.org>
Date: Sat, 24 Jan 2009 12:06:37 +0000
From: Andrew Walrond <andrew@walrond.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: serial8250 madness
References: <497A0164.90409@walrond.org>
In-Reply-To: <497A0164.90409@walrond.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Walrond wrote:
>
> Machine B
>
> ttyS0 and ttyS1 will both receive, but neither will send. Go figure. 
> Tested using a null modem cable, setserial and cu against the known 
> good machine above.
>
It's not just the linux kernel; grub also refuses to send anything using 
this board's serial devices, so I think the hardware/bios must be 
stuffed somehow.

And since this is an MSI board with 'Microsoft only Live Bios Update 
software (tm)' as the only bios upgrade option, it will be visiting the 
skip in short order.

I haven't seen this before; I hope it's not becoming a new fashion.

Andrew Walrond

