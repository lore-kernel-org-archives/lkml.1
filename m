Return-Path: <linux-kernel-owner+w=401wt.eu-S965395AbXA3OHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965395AbXA3OHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965456AbXA3OHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:07:40 -0500
Received: from mail.enyo.de ([212.9.189.167]:3466 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965395AbXA3OHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:07:39 -0500
X-Greylist: delayed 1282 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 09:07:39 EST
From: Florian Weimer <fw@deneb.enyo.de>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com>
Date: Tue, 30 Jan 2007 14:45:57 +0100
In-Reply-To: <20070130012904.GA9617@kroah.com> (Greg KH's message of "Mon, 29
	Jan 2007 17:29:04 -0800")
Message-ID: <877iv4ljai.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH:

> Yes, that's right, the Linux kernel community is offering all companies
> free Linux driver development.  No longer do you have to suffer through
> all of the different examples in the Linux Device Driver Kit, or pick
> through the thousands of example drivers in the Linux kernel source
> tree trying to determine which one is the closest to what you need to
> do.

Very nice spin indeed.

This reminds of the the utterly broken dl2k network driver (which has
got interrupt handling problems and doesn't properly synchronize with
DMA transfers, IIRC).  Hardware specs are available, and I guess I
could even provide a hardware sample, maybe even two.  (If the
community provides driver support, it shouldn't matter if the vendor
actually supports development.)
