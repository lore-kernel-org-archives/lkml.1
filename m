Return-Path: <linux-kernel-owner+w=401wt.eu-S1763583AbYFNA35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763583AbYFNA35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760038AbYFNA3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:29:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931AbYFNA32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:29:28 -0400
Date: Fri, 13 Jun 2008 17:28:02 -0700
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ANNOUNCE] linux-staging tree created
Message-ID: <20080614002802.GD25585@kroah.com>
References: <20080610190540.GA25066@kroah.com> <43e72e890806130714k535b041evaf750209ea492c47@mail.gmail.com> <20080613143328.GA16506@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613143328.GA16506@tuxdriver.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 10:33:29AM -0400, John W. Linville wrote:
> On Fri, Jun 13, 2008 at 07:14:32AM -0700, Luis R. Rodriguez wrote:
> 
> > This is great. To let this be useful for wireless we'll need
> > wireless-testing.git merged as we rely on it for the latest and
> > greatest. Is this a possibility?
> 
> > We have a few drivers which are not yet ready for
> > wireless-testing.git. Airgo is one.
> > 
> > Anyway, good stuff. Let me know what you think about letting this work
> > for wireless too.
> 
> I don't think directly pulling wireless-testing is a good idea of
> -staging for process-related reasons.  However I think we can arrange
> to send something for the new tree.  at76, airgo, and mrv8k are all
> decent candidates.

Sounds good to me.

> Greg, how does the -staging tree get managed?  Is it periodically
> rebuilt (like -next)?  Or would I need to send you pull requests?

Just send me patches, it's a quilt tree.

thanks,

greg k-h
