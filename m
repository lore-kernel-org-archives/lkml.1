Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbYBGNB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbYBGNB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758997AbYBGNBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:01:14 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:44754 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758959AbYBGNBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:01:13 -0500
Date: Thu, 7 Feb 2008 14:01:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Hans-J??rgen Koch <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080207130117.GA18750@uranus.ravnborg.org>
References: <20080207133805.13f092ff@dilbert.local> <20080207125824.GB7111@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207125824.GB7111@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 07:58:24AM -0500, Christoph Hellwig wrote:
> On Thu, Feb 07, 2008 at 01:38:05PM +0100, Hans-J??rgen Koch wrote:
> > From: Hans J Koch <hjk@linutronix.de>
> > To: linux-kernel@vger.kernel.org
> > Cc: linux-arm-kernel@lists.arm.linux.org.uk
> > Cc: Greg KH <greg@kroah.com>
> > Subject: arch/arm/Kconfig: Make UIO available on ARM architecture
> > 
> > Source drivers/uio/Kconfig to make UIO available in menuconfig if ARCH=arm.
> > I already posted this a few months ago, but it got lost somehow.
> 
> Any chance to make arm finally use drivers/Kconfig?  It's a bit silly
> that arm still is crapping around while even s390 uses it.
rmk said that it should be easy to check the amount of work needed to do so.
But I have not had time to look into it yet - hopefully someone
in ARM land could fix it.

	Sam
