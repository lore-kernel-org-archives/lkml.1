Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbXFMV7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbXFMV7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbXFMV65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:58:57 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53934 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbXFMV64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:58:56 -0400
Date: Wed, 13 Jun 2007 14:59:46 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH -mm 0/7] PM: Remove unused and unnecessary features
	from suspend and resume core
Message-ID: <20070613215946.GA26206@kroah.com>
References: <200706131551.51336.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706131551.51336.rjw@sisk.pl>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 03:51:48PM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> The following series of patches removes some unused and unnecessary features
> from the suspend and resume core code.

These are the same as you sent out the other day, right?

If so, I'll put them in my tree, trying to catch up on my queue right
now.

thanks,

greg k-h
