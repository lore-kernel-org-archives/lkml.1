Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbZEKM5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbZEKM5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZEKM5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:57:07 -0400
Received: from relay3.sgi.com ([192.48.156.57]:37806 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752260AbZEKM5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:57:06 -0400
Date: Mon, 11 May 2009 07:57:02 -0500
From: Martin Hicks <mort@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com
Subject: Re: [kdb] [PATCH 0/13] RFC ONLY - kdb for kgdb
Message-ID: <20090511125702.GL14353@alcatraz.americas.sgi.com>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com> <20090511092204.GA19351@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511092204.GA19351@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, May 11, 2009 at 05:22:04AM -0400, Christoph Hellwig wrote:
> On Fri, May 08, 2009 at 04:23:07PM -0500, Jason Wessel wrote:
> > This patch series is a request for comments on several levels.
> > 

> 
> > 2) Would kdb folks be willing to use it if it was a front end to kgdb?
> 
> Yes.

absolutely.

> > 3) Does kdb have a future in the mainline kernel?
> 
> Well, if someone invest the effort to clean it up, cut it into small
> mergeable pieces and gets it done.

I'll play with these patches later today, Jason.

Thanks for getting this patchset out.
mh

