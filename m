Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZHFQx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZHFQx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZHFQx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:53:57 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4311 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbZHFQx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:53:57 -0400
Subject: Re: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM
 sections
From: Joe Perches <joe@perches.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090806164001.GA31507@flint.arm.linux.org.uk>
References: <20090806125751.7d0253ce@nij0285>
	 <20090806113104.GK31370@elf.ucw.cz>
	 <20090806120826.GC27773@flint.arm.linux.org.uk>
	 <4A7ACC8D.7030706@xenontk.org>
	 <20090806124048.GD27773@flint.arm.linux.org.uk>
	 <1249563730.10297.13.camel@Joe-Laptop.home>
	 <20090806133349.GF27773@flint.arm.linux.org.uk>
	 <1249568614.10297.20.camel@Joe-Laptop.home>
	 <20090806150322.GX2080@trinity.fluff.org>
	 <1249575528.3467.9.camel@Joe-Laptop.home>
	 <20090806164001.GA31507@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 09:53:31 -0700
Message-Id: <1249577611.3467.29.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 17:40 +0100, Russell King wrote:
> On Thu, Aug 06, 2009 at 09:18:48AM -0700, Joe Perches wrote:
> > It does add both linux-arm-kernel and linux-arm to section
> > SIMTEC EB2410ITX (BAST).  By the way, another section you
> > maintain, SIMTEC EB110ATX (Chalice CATS), has neither a
> > pattern entry nor a mailing list entry.  Should it?
> 
> I recently had to remove those pattern entries because they were plainly
> wrong (thanks to those who didn't CC anyone in the ARM community with
> those patches.)  EB110ATX != EBSA110.  See ce53895.

[cc's trimmed]

Nope.  Not the case.  I submitted that entry.
I cc'd both Ben and Vincent before submitting it.

> I had asked the maintainer of that platform to submit a patch to add the
> correct entries.  Rather than having plainly bogus entries in there,
> let's have either nothing or the right entries.

I couldn't possibly disagree with that...

cheers, Joe

