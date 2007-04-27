Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbXD1RFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbXD1RFh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbXD1RFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:05:35 -0400
Received: from mail.suse.de ([195.135.220.2]:60211 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417AbXD1RFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:05:05 -0400
Date: Fri, 27 Apr 2007 16:55:53 -0700
From: Greg KH <gregkh@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Anton Vorontsov <cbou@mail.ru>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ANNOUNCE] battery2 git repository
Message-ID: <20070427235553.GC24476@suse.de>
References: <20070426232902.GA10423@zarina> <20070427000928.GA5303@suse.de> <1177653814.2755.466.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177653814.2755.466.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 07:03:34AM +0100, David Woodhouse wrote:
> On Thu, 2007-04-26 at 17:09 -0700, Greg KH wrote:
> > So, I'm still not quite understanding this, is David giving up on his
> > code now that you have pulled his changes into your tree?  Or is there
> > some reason there are still two competing versions here?
> 
> Anton hasn't pulled my changes -- it's a separate implementation,
> although very similar. In return for the account on git.infradead.org he
> said he was going to port the two drivers I already had (PMU and OLPC)
> to his framework.

Hopefully he took the driver model fixes you did.  Anton, care to send a
new set of patches, so we can review them?

thanks,

greg k-h
