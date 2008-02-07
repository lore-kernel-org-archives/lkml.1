Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbYBGM6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbYBGM6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYBGM60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:58:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbYBGM6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:58:25 -0500
Date: Thu, 7 Feb 2008 07:58:24 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Hans-J??rgen Koch <hjk@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM
	architecture
Message-ID: <20080207125824.GB7111@infradead.org>
References: <20080207133805.13f092ff@dilbert.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207133805.13f092ff@dilbert.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 01:38:05PM +0100, Hans-J??rgen Koch wrote:
> From: Hans J Koch <hjk@linutronix.de>
> To: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.arm.linux.org.uk
> Cc: Greg KH <greg@kroah.com>
> Subject: arch/arm/Kconfig: Make UIO available on ARM architecture
> 
> Source drivers/uio/Kconfig to make UIO available in menuconfig if ARCH=arm.
> I already posted this a few months ago, but it got lost somehow.

Any chance to make arm finally use drivers/Kconfig?  It's a bit silly
that arm still is crapping around while even s390 uses it.

