Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbXBWUwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbXBWUwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 15:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbXBWUwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 15:52:31 -0500
Received: from palrel13.hp.com ([156.153.255.238]:56899 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933214AbXBWUwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 15:52:31 -0500
Date: Fri, 23 Feb 2007 14:52:29 -0600
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mike.miller@hp.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, gregkh@novell.com
Subject: Re: [Patch 1/2] cciss: fix for 2TB support
Message-ID: <20070223205229.GB10570@beardog.cca.cpqcorp.net>
References: <20070221211039.GA2672@beardog.cca.cpqcorp.net> <20070221191427.9b7cf4b0.akpm@linux-foundation.org> <20070222165123.GC2672@beardog.cca.cpqcorp.net> <20070222132434.d84d3248.akpm@linux-foundation.org> <1172180484.3378.34.camel@mulgrave.il.steeleye.com> <20070222220225.GC14162@beardog.cca.cpqcorp.net> <1172182001.3378.38.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172182001.3378.38.camel@mulgrave.il.steeleye.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 04:06:41PM -0600, James Bottomley wrote:
> On Thu, 2007-02-22 at 16:02 -0600, Mike Miller (OS Dev) wrote:
> > Will this patch for my patch work for now?
> 
> Yes, I think that should be fine ... it's only a theoretical worry; at
> the moment sector_t is unsigned ... but just in case.
> 
> James
> 
> 
Andrew,
Are you waiting for a new patch from me? Or is my patch's patch sufficient?

-- mikem
