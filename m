Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZEDXHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZEDXHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZEDXHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:07:46 -0400
Received: from kroah.org ([198.145.64.141]:47346 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbZEDXHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:07:46 -0400
Date: Mon, 4 May 2009 16:01:47 -0700
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] amd-iommu: fix iommu flag masks
Message-ID: <20090504230147.GA10086@kroah.com>
References: <1241431907-30225-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241431907-30225-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 12:11:47PM +0200, Joerg Roedel wrote:
> Impact: fix initialization of iommu flags
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

This patch does not look to be in Linus's tree yet.

What is the plan for it to get there?

thanks,

greg k-h
