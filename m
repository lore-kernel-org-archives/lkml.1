Return-Path: <linux-kernel-owner+w=401wt.eu-S932702AbYEFWAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbYEFWAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765704AbYEFWAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:00:20 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:47450 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760402AbYEFWAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:00:17 -0400
Message-ID: <4820D522.50104@keyaccess.nl>
Date: Wed, 07 May 2008 00:01:06 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] PNP: add AD1815 and AD1816 quirks
References: <481FAC37.6090703@keyaccess.nl> <200805061308.14673.bjorn.helgaas@hp.com> <4820C846.2040205@keyaccess.nl> <200805061527.21134.bjorn.helgaas@hp.com>
In-Reply-To: <200805061527.21134.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-05-08 23:27, Bjorn Helgaas wrote:

> This part is just my general unhappiness about options like
> "acpi_irq_nobalance" and "acpi_irq_isa=".  I was just wondering
> what Windows does when it can't assign PNP IRQs.  Does it assign
> them all before PCI, so they know they have enough?  Do it
> dynamically move PCI interrupts?  Do it require explicit boot
> flags like Linux does?  Or maybe nobody even needs those flags
> on Linux, and the flags are effectively unused.

That's for Len. I haven't used Windows in eight or nine years now and am 
consequently progressively ignorant of it.

Rene.
