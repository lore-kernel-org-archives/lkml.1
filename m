Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZJAT7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZJAT7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZJAT7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:59:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:37570 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbZJAT7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:59:44 -0400
Date: Thu, 1 Oct 2009 12:56:51 -0700
From: Greg KH <gregkh@suse.de>
To: Peter Volkov <pva@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.31.1
Message-ID: <20091001195651.GA28591@suse.de>
References: <20090924174002.GE17077@kroah.com>
 <1253863121.22793.24.camel@tablet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1253863121.22793.24.camel@tablet>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 11:18:41AM +0400, Peter Volkov wrote:
> В Чтв, 24/09/2009 в 10:40 -0700, Greg KH пишет:
> > I'm announcing the release of the 2.6.31.1 kernel.  All users of the
> > 2.6.31 kernel series are very strongly encouraged to upgrade.
> 
> Looks like the following patch was missed:
> http://patchwork.kernel.org/patch/48380/
> 
> and link to the thread where it was discussed:
> http://lkml.org/lkml/2009/9/17/397
> 
> Please, add it to 2.6.31. Thanks.

It just didn't make it in time.  It is now queued up for the next
.31-stable release.

thanks,

greg k-h
