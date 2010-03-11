Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab0CKR7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:59:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:41811 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933451Ab0CKR7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:59:11 -0500
Date: Thu, 11 Mar 2010 09:58:04 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: increase CONFIG_NODES_SHIFT max to 10
Message-ID: <20100311175804.GA32333@suse.de>
References: <alpine.DEB.2.00.1003101537330.30724@chino.kir.corp.google.com> <20100311132354.GA26600@elte.hu> <20100311140623.GA9346@suse.de> <20100311141533.GB31225@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311141533.GB31225@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 03:15:33PM +0100, Ingo Molnar wrote:
> 
> * Greg KH <gregkh@suse.de> wrote:
> 
> > > erm. Alas I cannot merge it in the x86 tree without that fix being 
> > > upstream. Why for v2.6.35 - shouldnt that be v2.6.34?
> > 
> > If it needs to go in before .35, or it should go through Ingo's trees, I 
> > have no objection.
> 
> It does not 'need' to be in .34 but if the fix is trivial enough then you 
> could give it a try?

The fix is trivial, I'll queue it up.

thanks,

greg k-h
