Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbXCZS7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbXCZS7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXCZS7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:59:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46527 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbXCZS73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:59:29 -0400
Date: Mon, 26 Mar 2007 11:57:18 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] clockevents: remove bad designed sysfs support for now
Message-ID: <20070326185718.GA4547@kroah.com>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <1174900868.4182.21.camel@chaos> <20070326092503.GA27109@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326092503.GA27109@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 11:25:05AM +0200, Ingo Molnar wrote:
> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > The current sysfs support of clockevents does not obey the "only one 
> > value per file" rule.
> > 
> > The real fix is not 2.6.21 material. Therefor remove the sysfs support 
> > for now.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Thanks Thomas for doing this.

greg k-h
