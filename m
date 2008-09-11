Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYIKKNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYIKKNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYIKKNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:13:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYIKKNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:13:39 -0400
Date: Thu, 11 Sep 2008 02:31:38 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <gregkh@suse.de>, Alexander Beregalov <a.beregalov@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/module: fix warning when
	!CONFIG_DYNAMIC_PRINTK_DEBUG
Message-ID: <20080911093138.GA26237@kroah.com>
References: <20080820141329.GB7622@orion> <20080820142453.GA31886@suse.de> <20080820151303.GA1754@suse.de> <20080821203539.GB6273@redhat.com> <20080821204513.GC6273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821204513.GC6273@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 04:45:13PM -0400, Jason Baron wrote:
> On Thu, Aug 21, 2008 at 04:35:39PM -0400, Jason Baron wrote:
> > looks much cleaner. thanks.
> > 
> > we can simplify this module code a bit more...how about the following on top of
> > what you did? 
> > 
> > thanks,
> > 
> > -Jason
> > 
> 
> or better yet, without trailing whitespace...

Looks good, thanks, I've merged it in.

greg k-h
