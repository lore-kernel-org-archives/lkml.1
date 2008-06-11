Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbYFKDdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbYFKDdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 23:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbYFKDdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 23:33:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbYFKDdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 23:33:17 -0400
Date: Tue, 10 Jun 2008 20:29:48 -0700
From: Greg KH <greg@kroah.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors@vger.kernel.org, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] linux-staging tree created
Message-ID: <20080611032948.GB4483@kroah.com>
References: <20080610190540.GA25066@kroah.com> <1213146346.16146.17.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213146346.16146.17.camel@nigel-laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 11:05:46AM +1000, Nigel Cunningham wrote:
> Hi.
> 
> Would you consider including TuxOnIce in it?
> 
> I do still want to get it merged and would appreciate feedback.

Is the patch "stand-alone", only adding new code in discrete chunks like
a new driver or filesystem would?

If not, I don't think it is relevant.  Odds are you want to be your own
series of patches, like we discussed years ago, right?

thanks,

greg k-h
