Return-Path: <linux-kernel-owner+w=401wt.eu-S1750824AbXBMKZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750824AbXBMKZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXBMKZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:25:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58684 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbXBMKZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:25:10 -0500
Subject: Re: SATA-performance: Linux vs. FreeBSD
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Martin A. Fink" <fink@mpe.mpg.de>, Matthias Schniedermeyer <ms@citd.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <p73r6sugvb6.fsf@bingen.suse.de>
References: <200702121502.17130.fink@mpe.mpg.de>
	 <200702121856.29729.fink@mpe.mpg.de> <45D0F8EE.7020604@citd.de>
	 <200702131025.15964.fink@mpe.mpg.de>
	 <1171361290.12771.77.camel@laptopd505.fenrus.org>
	 <p73r6sugvb6.fsf@bingen.suse.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 13 Feb 2007 11:25:00 +0100
Message-Id: <1171362301.12771.83.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 12:18 +0100, Andi Kleen wrote:
> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > > > 
> > > The problem is: FreeBSD is fast, but lacks of some special drivers. Linux has 
> > > all drivers but access to harddisk is unpredictable and thus unreliable!
> > > What can I do??
> > 
> > 
> > there's several tunables you can do;
> 
> [...] Well Linux certainly should perform better out of the box
> on such a simple configuration.

no argument from me there; first need to find out which piece is wrong
> 
> Something is wrong especially when the CPU usage is so high.

I'll buy that, yet there's plenty of cpu time available so that
shouldn't be all that much of a limit on the throughput... there's still
headroom

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

