Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbZEEVY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbZEEVY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZEEVYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:24:20 -0400
Received: from kroah.org ([198.145.64.141]:39225 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbZEEVYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:24:19 -0400
Date: Tue, 5 May 2009 07:55:31 -0700
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] amd-iommu: fix iommu flag masks
Message-ID: <20090505145531.GA4579@kroah.com>
References: <1241431907-30225-1-git-send-email-joerg.roedel@amd.com> <20090504230147.GA10086@kroah.com> <20090505102137.GD4059@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505102137.GD4059@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 12:21:37PM +0200, Joerg Roedel wrote:
> On Mon, May 04, 2009 at 04:01:47PM -0700, Greg KH wrote:
> > On Mon, May 04, 2009 at 12:11:47PM +0200, Joerg Roedel wrote:
> > > Impact: fix initialization of iommu flags
> > > 
> > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > 
> > This patch does not look to be in Linus's tree yet.
> > 
> > What is the plan for it to get there?
> 
> I sent it to Ingo for 2.6.30. I think it will be upstream soon.

Please send it to stable@kernel.org when it goes into Linus's tree, so
we know to apply it then.

thanks,

greg k-h
