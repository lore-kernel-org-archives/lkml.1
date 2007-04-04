Return-Path: <linux-kernel-owner+w=401wt.eu-S2992986AbXDDQjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992986AbXDDQjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992995AbXDDQjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:39:21 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:46420 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992986AbXDDQjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:39:20 -0400
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm
	tree
From: Daniel Walker <dwalker@mvista.com>
To: tglx@linutronix.de
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1175417035.28263.42.camel@localhost.localdomain>
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net>
	 <1175417035.28263.42.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 09:38:32 -0700
Message-Id: <1175704712.15973.35.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-01 at 10:43 +0200, Thomas Gleixner wrote:
> On Sat, 2007-03-31 at 22:23 -0700, akpm@linux-foundation.org wrote:
> > The patch titled
> >      clocksource: driver initialize list value
> > has been added to the -mm tree.  Its filename is
> >      clocksource-driver-initialize-list-value.patch
> > 
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > 
> > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> > out what to do about this
> > 
> > ------------------------------------------------------
> > Subject: clocksource: driver initialize list value
> > From: Daniel Walker <dwalker@mvista.com>
> > 
> > Update drivers/clocksource/ with list initialization.
> 
> As others pointed out already, can we please have some usefull
> description why this change is necessary ? i.e. that it is a preparatory
> patch to simplify the clocksource registration logic.
> 
> 	tglx

I was planning to do it after Andrew release the next -mm then use same
patch names he has and just submit to him.. I'm not sure what the
easiest method is, and I'd rather like to avoid re-submitting to LKML ..

Daniel

