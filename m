Return-Path: <linux-kernel-owner+w=401wt.eu-S965616AbXBHXfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965616AbXBHXfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965608AbXBHXfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:35:05 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:54349 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965616AbXBHXfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:35:03 -0500
Date: Thu, 8 Feb 2007 18:34:49 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070208233449.GC18899@athena.road.mcmartin.ca>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208150710.1324f6b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 03:07:10PM -0800, Andrew Morton wrote:
> I'm getting fed up of holding onto hundreds of patches against subsystem
> trees, sending them over and over again seeing and nothing happen.  I sent 242
> patches out to subsystem maintainers on Monday and look at what's still here.
> 
> parisc-fix-module_param-iommu-permission.patch
> pa-risc-fix-bogus-warnings-from-modpost.patch
> use-__u64-rather-than-u64-in-parisc-statfs-structs.patch
> 
>  -> kyle
> 

Sorry, I thought the mails meant you were dumping to Linus. Will
merge.
