Return-Path: <linux-kernel-owner+w=401wt.eu-S1423021AbXCBLKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423021AbXCBLKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423023AbXCBLKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:10:39 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4262 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423021AbXCBLKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:10:38 -0500
Date: Fri, 2 Mar 2007 11:10:30 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
Message-ID: <20070302111030.GB2824@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070302110420.GA2824@flint.arm.linux.org.uk> <20070302030833.4aea2574.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302030833.4aea2574.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 03:08:33AM -0800, Andrew Morton wrote:
> On Fri, 2 Mar 2007 11:04:20 +0000 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
> > > Changes since 2.6.20-mm2:
> > > 
> > >  origin.patch
> > >  git-acpi.patch
> > >  git-alsa.patch
> > >  git-avr32.patch
> > 
> > I guess you're not pulling the ARM master branch in addition to the devel
> > branch?  The master branch contains fixes for -rc kernels whereas devel
> > contains stuff for post-rc kernels.
> 
> Nope, I'm pulling git+ssh://master.kernel.org/home/rmk/linux-2.6-arm.git#devel
> 
> But arm is busted in rc2-mm1 due to missing utrace bits.

What's utrace and why is it mandatory?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
