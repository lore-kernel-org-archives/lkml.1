Return-Path: <linux-kernel-owner+w=401wt.eu-S1764331AbXEWAZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764331AbXEWAZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbXEWAZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:25:42 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:56109 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763654AbXEWAZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:25:41 -0400
Date: Tue, 22 May 2007 17:25:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Greg KH <greg@kroah.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the
	-stable cycle
Message-ID: <20070523002534.GB3390@sequoia.sous-sol.org>
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com> <46533EA8.7020602@garzik.org> <20070522193538.GA885@kroah.com> <20070522220044.GB3429@sequoia.sous-sol.org> <46537314.4080605@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46537314.4080605@garzik.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeff Garzik (jeff@garzik.org) wrote:
> Chris Wright wrote:
> >2) In theory new hardware can seem to work with a simple PCI ID
> >update, and later we find it needs extra quirk handling or specific
> >driver support.  This could mean adding buggy support for new hardware
> >to -stable.  In practice, hopefully this isn't a real issue.
> 
> No need to worry about theory.  Since you are (or should be???) taking 
> stuff solely from upstream, you should already know what is needed, or not.

Yup, it's definitely handwavy.  If it's a problem we can address it then.

thanks,
-chris
