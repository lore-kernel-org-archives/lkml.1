Return-Path: <linux-kernel-owner+w=401wt.eu-S1760522AbXGIUYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760522AbXGIUYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXGIUYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:24:36 -0400
Received: from waste.org ([66.93.16.53]:47009 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbXGIUYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:24:36 -0400
Date: Mon, 9 Jul 2007 15:24:15 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
Message-ID: <20070709202414.GT11115@waste.org>
References: <1183875574.6005.275.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183875574.6005.275.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 04:19:34PM +1000, Rusty Russell wrote:
> Matt wrote:
> > This interface is primarily useful for doing memory profiling and not much use
> > on deployed embedded boxes.  Make it optional.  Together with
> > /proc/pid/clear_refs, this save a few K.
> 
> How about a single config option for all these?

I suppose. This looks like half a patch though. I think you forgot a
quilt add somewhere.

-- 
Mathematics is the supreme nostalgia of our time.
