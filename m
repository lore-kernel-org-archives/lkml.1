Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbXHBOcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbXHBOcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbXHBOcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:32:14 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3287 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbXHBOcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:32:13 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.23-rc1-mm2
Date: Thu, 2 Aug 2007 16:32:09 +0200
User-Agent: KMail/1.9.5
Cc: Jiri Kosina <jikos@jikos.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
References: <Pine.LNX.4.44L0.0708021019400.3611-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0708021019400.3611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708021632.10074.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > >  =======================
> > > > > uhci_hcd 0000:00:0c.0: dma_pool_free buffer-32, 6b6b6b6b/6b6b6b6b
> > > > > (bad dma)
> > >
> > > Mariusz,
> > >
> > > I guess the patch below (which I have just added to my tree) fixes
> > > that, right? Thanks.
> >
> > Yes - that's correct. This patch fixes the bug. Thanks.
>
> Does it also fix the "dma_pool_free" error?

Yes - it does.

Regards,

	Mariusz
