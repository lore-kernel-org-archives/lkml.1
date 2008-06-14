Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbYFNA3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbYFNA3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbYFNA32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:29:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43045 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918AbYFNA31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:29:27 -0400
Date: Fri, 13 Jun 2008 17:27:22 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       linux-next@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ANNOUNCE] linux-staging tree created
Message-ID: <20080614002722.GC25585@kroah.com>
References: <20080610190540.GA25066@kroah.com> <43e72e890806130714k535b041evaf750209ea492c47@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890806130714k535b041evaf750209ea492c47@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 07:14:32AM -0700, Luis R. Rodriguez wrote:
> This is great. To let this be useful for wireless we'll need
> wireless-testing.git merged as we rely on it for the latest and
> greatest. Is this a possibility?

Hm, why?  Is it really needed for you to have this pulled in?  What is
keeping these drivers from being added to the -next tree today?

> We have a few drivers which are not yet ready for
> wireless-testing.git. Airgo is one.

If you have individual drivers, I'd be glad to take them into the tree
if you think it will help out.  Just send me a patch that can build
properly.

thanks,

greg k-h
