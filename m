Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbZJHXKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbZJHXKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932196AbZJHXKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:10:33 -0400
Received: from kroah.org ([198.145.64.141]:34442 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbZJHXKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:10:31 -0400
Date: Thu, 8 Oct 2009 15:47:25 -0700
From: Greg KH <greg@kroah.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: gregkh@suse.de, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au,
       akpm@linux-foundation.org, rientjes@google.com
Subject: Re: [PATCH] linux-next: 20090929 - android driver build breaks
Message-ID: <20091008224725.GA22949@kroah.com>
References: <20090929140404.dfb2c5f5.sfr@canb.auug.org.au>
 <20090929152027.GC4373@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929152027.GC4373@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 08:50:27PM +0530, Kamalesh Babulal wrote:
> Hi Greg,
> 
> 	next-20090929 randconfig build breaks with
> CONFIG_ANDROID_LOW_MEMORY_KILLER=y

Due to no support from Google, I've dropped the android code from the
staging tree for 2.6.33.

thanks,

greg k-h
