Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYBGO1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYBGO1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbYBGO0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:26:54 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38604 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbYBGO0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:26:54 -0500
Date: Thu, 7 Feb 2008 14:21:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Hans-J??rgen Koch <hjk@linutronix.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080207142104.GA28435@flint.arm.linux.org.uk>
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

Are we finally going to allow architecture modifications to drivers/Kconfig?
The answer to your question is identical to the answer to that question.
