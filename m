Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbZGWN5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbZGWN5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 09:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZGWN5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 09:57:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58627 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751523AbZGWN5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 09:57:03 -0400
Date: Thu, 23 Jul 2009 14:57:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Vikram Pandita <vikram.pandita@ti.com>, Alan Cox <alan@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Eric Whitney <eric.whitney@hp.com>, Rich Freiss <richard.freiss@hp.com>
Subject: Re: Boot Hang - mmotm 090716 - serial 8250 irq flags support
Message-ID: <20090723145754.3f001c4e@lxorguk.ukuu.org.uk>
In-Reply-To: <1248353462.5674.80.camel@useless.americas.hpqcorp.net>
References: <1248291948.4490.67.camel@useless.americas.hpqcorp.net>
	<20090723113353.7da8f6f9@lxorguk.ukuu.org.uk>
	<1248353462.5674.80.camel@useless.americas.hpqcorp.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> </system1>hpiLO-> Virtual Serial Port active: IO=0x02F8 INT=3
> 
> Perhaps Bjorn or Rich could comment on the hardware setup...

Ok thats a generic ISA port

The rest fits the patch I sent you so hopefully that fixes it and if so
I'll make sure the corrected one ends up in -next.

Alan
