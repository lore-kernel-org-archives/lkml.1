Return-Path: <linux-kernel-owner+w=401wt.eu-S1762492AbXHUSu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762492AbXHUSu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759917AbXHUSuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:50:19 -0400
Received: from ns1.suse.de ([195.135.220.2]:53268 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760548AbXHUSuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:50:17 -0400
Date: Tue, 21 Aug 2007 11:48:41 -0700
From: Tony Jones <tonyj@suse.de>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: [patch 09/14] Convert from class_device to device for SPI
Message-ID: <20070821184841.GA28348@suse.de>
References: <20070820224806.154198000@suse.de> <20070820225122.627806000@suse.de> <20070821150119.GH26519@suse.de> <200708211128.28552.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708211128.28552.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 11:28:28AM -0700, David Brownell wrote:
> On Tuesday 21 August 2007, Tony Jones wrote:
> > On Mon, Aug 20, 2007 at 03:48:15PM -0700, tonyj@suse.de wrote:
> > > 
> > > Convert from class_device to device for drivers/spi.  This is part of the work 
> > > to eliminate struct class_device.
> > 
> > Signed-off-by: Tony Jones <tonyj@suse.de>
> 
> Yeah, "no signoff" was one of my first reactions to that.  :)

Yeah, sorry, had it in the first patch but cut-n-pasted it into oblivion :)

> Can you update the Documentation/spi/spi-summary text which is
> invalidated by this change?  That's part of why I rejected an

Will do. Thanks!

Tony
