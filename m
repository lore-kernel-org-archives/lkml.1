Return-Path: <linux-kernel-owner+w=401wt.eu-S932392AbZJ0UoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbZJ0UoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932376AbZJ0UoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:44:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:43686 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384AbZJ0UoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:44:12 -0400
Date: Tue, 27 Oct 2009 13:38:07 -0700
From: Greg KH <gregkh@suse.de>
To: david@lang.hm
Cc: "John W. Linville" <linville@tuxdriver.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091027203807.GA28756@suse.de>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
 <20091023161006.GA1580@ucw.cz>
 <20091026165518.GE2792@tuxdriver.com>
 <alpine.DEB.2.00.0910261013430.11504@asgard.lang.hm>
 <20091026184734.GA21591@suse.de>
 <alpine.DEB.2.00.0910262106050.14994@asgard.lang.hm>
 <20091027140812.GC17208@suse.de>
 <alpine.DEB.2.00.0910271136530.11504@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910271136530.11504@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 11:39:54AM -0700, david@lang.hm wrote:
> >> now it appears that you have to have 'enough' users (an amount undefined)
> >
> > That amount would be 1.  This driver does not have that, so it can be
> > removed.
> 
> while I definantly agree that this driver is unlikly to have many users, 
> unless it is known broken (which David Miller has stated that it is, but 
> had not been mentioned previously in this thread), how can you know that 
> the number of users has dropped below 1?

As the driver is known to be broken, I would think that the number of
users has dropped below 1 :)

And again, if someone for this driver shows up, it is _trivial_ to add
it back to the tree.

thanks,

greg k-h
