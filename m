Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbYDKVxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbYDKVxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbYDKVxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:53:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45624 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501AbYDKVxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:53:06 -0400
Date: Fri, 11 Apr 2008 14:41:34 -0700
From: Greg KH <greg@kroah.com>
To: Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v2] [RFC] UIO: generic platform driver
Message-ID: <20080411214134.GC32522@kroah.com>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410224804.GI3193@local> <20080411062106.GA18096@digi.com> <20080411092158.GB31625@digi.com> <20080411104835.GB19973@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411104835.GB19973@digi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 12:48:35PM +0200, Uwe Kleine-K?nig wrote:
> Hello,
> 
> Uwe Kleine-K?nig wrote:
> > +			dev_warn(&pdev->dev, "device has more than "
> > +					stringify(MAX_UIO_MAPS)
> This must read __stringify(MAX_UIO_MAPS).  Sorry, I didn't compile test
> that.

Care to send the latest version of this, I'm a bit lost as to what
people want me to apply...

thanks,

greg k-h
