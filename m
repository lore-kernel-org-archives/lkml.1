Return-Path: <linux-kernel-owner+w=401wt.eu-S1765616AbYEFQm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765616AbYEFQm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759924AbYEFQmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:42:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43768 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760174AbYEFQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:42:09 -0400
Date: Tue, 6 May 2008 08:44:08 -0700
From: Greg KH <greg@kroah.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] [POWERPC] mpc5200: Fix unterminated of_device_id
	table
Message-ID: <20080506154408.GA32680@kroah.com>
References: <20080429124343.24177.15349.stgit@trillian.secretlab.ca> <fa686aa40805060741vd4befa4i1ea5ab6df4d54d9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40805060741vd4befa4i1ea5ab6df4d54d9b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 08:41:44AM -0600, Grant Likely wrote:
> Greg,
> 
> This patch is already in mainline; but it needs to be backported to
> the stable tree.  Can you please pick it up?

In the future, please email the stable@kernel.org alias for things you
want to go into the stable tree, otherwise there is a very good chance
it will be missed.

Also, please mention the git id for the commit in Linus's tree so we
don't have to go digging for it.

I'll go add this to the to-apply queue.

thanks,

greg k-h
