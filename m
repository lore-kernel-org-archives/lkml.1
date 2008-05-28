Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbYE1Rb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbYE1Rb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYE1RbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:31:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40016 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYE1RbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:31:19 -0400
Date: Wed, 28 May 2008 10:17:41 -0700
From: Greg KH <greg@kroah.com>
To: Michael Karcher <karcher@physik.fu-berlin.de>
Cc: smurf@smurf.noris.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb-serial: option: Don't match Huawei driver CD images
Message-ID: <20080528171741.GA11307@kroah.com>
References: <1208472569.14194.5.camel@hermes2.karcher.local> <20080418032405.GB8754@kroah.com> <1208498494.14194.28.camel@hermes2.karcher.local> <1208500241.4749.3.camel@hermes2.karcher.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208500241.4749.3.camel@hermes2.karcher.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 08:30:41AM +0200, Michael Karcher wrote:
> 
> Am Freitag, den 18.04.2008, 08:01 +0200 schrieb Michael Karcher:
> > Am Donnerstag, den 17.04.2008, 20:24 -0700 schrieb Greg KH:
> > > What is this patch against?  We have a change that went into 2.6.25
> > > after 2.6.25-rc9 that should make this patch not be needed.
> > The patch is developed against 2.6.25-rc8 + some git patches, but I have
> > forward-ported it to current git.
> > 
> > I *guess* you are talking about commit aad8a278 (USB: support more
> > Huawei data card product IDs), as I could not find .
> insert "any other patches applying to usb/usb-serial that might be
> involved" before the full stop.
> [...]
> 
> > > Can you try that release and verify this?
> > I will try with a current git kernel without my patch and report back,
> > but I will be surprised if the problem described above is gone. System
> > is currently compiling.
> Kernel compiled & booted. Won't work without the patch.

Oops, sorry, I lost this message in the queue.

Can you regenerate your patch against 2.6.26-rc4 and resend it?

thanks,

greg k-h
