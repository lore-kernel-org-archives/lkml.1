Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbXHBOUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbXHBOUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbXHBOUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:20:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50763 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753525AbXHBOUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:20:35 -0400
Date: Thu, 2 Aug 2007 10:20:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
cc: Jiri Kosina <jikos@jikos.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.23-rc1-mm2
In-Reply-To: <200708021147.33887.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.44L0.0708021019400.3611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Mariusz Kozlowski wrote:

> > > >  =======================
> > > > uhci_hcd 0000:00:0c.0: dma_pool_free buffer-32, 6b6b6b6b/6b6b6b6b (bad dma)
> > 
> > Mariusz,
> > 
> > I guess the patch below (which I have just added to my tree) fixes that, 
> > right? Thanks.
> 
> Yes - that's correct. This patch fixes the bug. Thanks.

Does it also fix the "dma_pool_free" error?

Alan Stern

