Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbXKMUUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbXKMUUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761271AbXKMUUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:20:18 -0500
Received: from mail.suse.de ([195.135.220.2]:48248 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760994AbXKMUUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:20:16 -0500
Date: Tue, 13 Nov 2007 12:14:19 -0800
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Philip Mucci <mucci@cs.utk.edu>, eranian@hpl.hp.com,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Perfmon <perfmon@napali.hpl.hp.com>, Andi Kleen <andi@firstfloor.org>,
       perfmon2-devel@lists.sourceforge.net,
       OSPAT devel <ospat-devel@cs.utk.edu>,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071113201419.GA26487@suse.de>
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113120728.4342e7d7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 12:07:28PM -0800, Andrew Morton wrote:
> 
> So.  If what I am saying is correct then the best course of action would be
> for Stephane to help us all to understand what these features are and why
> we need them.  The ideal way in which to do this is
> 
> [patch] perfmon: core
> [patch] perfmon: whizzy feature #1
> [patch] perfmon: whizzy feature #2
> [patch] perfmon: whizzy feature #3
> 
> etc.  Where the changelog in each whizzy-feature-n explains what it does,
> why it does it and why our users need it.

I agree.  Right now their git tree has over 80 patches in it, without
descriptions like this to help those of us who want to review and help
out, it is quite difficult.

thanks,

greg k-h
