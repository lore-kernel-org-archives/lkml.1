Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbXG3LyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbXG3LyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 07:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbXG3Lxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 07:53:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53285 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759361AbXG3Lxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 07:53:54 -0400
Date: Mon, 30 Jul 2007 13:53:31 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alois =?utf-8?Q?Ne=C5=A1por?= <alois.nespor@gmail.com>,
       Bernhard Kaindl <bk@suse.de>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci=assign-busses
Message-ID: <20070730115331.GO16817@stusta.de>
References: <6c9774880707300129if10dbf4n25c5077f02c940e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6c9774880707300129if10dbf4n25c5077f02c940e3@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard?

cu
Adrian

On Mon, Jul 30, 2007 at 10:29:07AM +0200, Alois Nešpor wrote:
> Hello,
> 
> 
> I view dmesg and find:  "PCI: Bus #0b (-#0e) is hidden behind
> transparent bridge #0a (-#0b) (try 'pci=assign-busses')
> Please report the result to linux-kernel to fix this permanently"
> 
> First, i have laptop Fujitsu Siemens Amilo Pro v3505.
> 
> dmesg:
> "Yenta: Raising subordinate bus# of parent bus (#0a) from #0b to #0e"
> without pci=assign-busses and nothing with pci=assign-busses.
> 
> I use pci=assign-busses and all works fine, possibly better.
> 
>  Thank you.
> 
> Regards,
>              Alois Nespor, Czech Republic

