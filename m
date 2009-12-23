Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbZLWQdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbZLWQdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 11:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbZLWQdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 11:33:49 -0500
Received: from kroah.org ([198.145.64.141]:58463 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbZLWQds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 11:33:48 -0500
Date: Wed, 23 Dec 2009 08:33:31 -0800
From: Greg KH <greg@kroah.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: Staging tree status for the .33 kernel merge
Message-ID: <20091223163331.GB26904@kroah.com>
References: <20091223005447.GA28941@kroah.com> <20091223105315.GA27229@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223105315.GA27229@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 11:53:15AM +0100, Sebastian Andrzej Siewior wrote:
> * Greg KH | 2009-12-22 16:54:47 [-0800]:
> 
> >Here's a summary of the state of the drivers/staging/ tree, basically
> >what will be coming in the 2.6.33 merge, and what the status of the
> >different drivers are so far.
> 
> I can't find usbip in your summary. Is there nothing to say or did you
> just forgot about it?

Oops, I forgot about it.  It's slated to be removed in .35 as well,
because no one is working on it.

thanks,

greg k-h
