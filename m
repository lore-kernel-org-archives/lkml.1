Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbXJWInS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbXJWInS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 04:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXJWInJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 04:43:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:43655 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbXJWInI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 04:43:08 -0400
Date: Tue, 23 Oct 2007 10:43:05 +0200
From: Jan Blunck <jblunck@suse.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] Use struct path in struct nameidata
Message-ID: <20071023084305.GJ17591@hasse.suse.de>
References: <20071022065352.GA6489@in.ibm.com> <20071022135758.GA17051@lst.de> <20071023023355.GA7829@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023023355.GA7829@in.ibm.com>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, Bharata B Rao wrote:

> On Mon, Oct 22, 2007 at 03:57:58PM +0200, Christoph Hellwig wrote:
> > 
> > Any reason we've got this patchset posted by three people now? :)
> 
> Two reasons actually !
> 
> - The set of patches posted by Jan last was on 2.6.23-rc8-mm1. So I
> thought let me help Andrew a bit by making them available on latest
> -mm :) And I didn't know that these were already under consideration
> by Andrew.

And they have been ported to 2.6.23-mm1 since the day it came out ...

> - The set of patches posted by Jan didn't even pass compile test for me.
> So I made sure that the patches compiled and worked on x86, x86_64 and powerpc.

And I merged your feedback already in ...

The thing is: how do we keep going from here? Do you want to send my patches
in the future or are you going to ask me before sending things out? We don't
need to duplicate the work here. I already put my quilt stack into a public
place for you to work on them but I don't like the way this is going on at the
moment.
