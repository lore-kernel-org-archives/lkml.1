Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbYGCS3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbYGCS3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 14:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYGCS2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 14:28:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbYGCS2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:28:54 -0400
Date: Thu, 3 Jul 2008 11:27:07 -0700
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Current List of Kernel Summit suggested
	topics from the discuss list
Message-ID: <20080703182707.GA12215@kroah.com>
References: <1214577710.3394.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214577710.3394.14.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 09:41:49AM -0500, James Bottomley wrote:
> Hi All,
> 
> This is the synopsis of the currently suggested topics so far.  That's
> not to say this is the list we will be doing, just to say that if
> there's something you think we should be discussing and it's not on the
> list, now would be a good time to add it (don't trust the programme
> committee magically to add it at the last minute ...)

Another proposal:

	Working well with other subsystems - Jean Delvare

	There are a number of times where different subsystems in the
	kernel need to interact with each other in ways that are not
	always easy or obvious.  This talk will be about some examples
	of how this has been done well, as well as work to figure out
	how to handle this better in the future.

thanks,

greg k-h
