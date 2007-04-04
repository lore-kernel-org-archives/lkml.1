Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbXDDUHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbXDDUHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbXDDUHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:07:30 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54969 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbXDDUH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:07:29 -0400
Date: Wed, 4 Apr 2007 12:58:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm
 tree
Message-Id: <20070404125853.1cf9b7b7.akpm@linux-foundation.org>
In-Reply-To: <1175704712.15973.35.camel@imap.mvista.com>
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net>
	<1175417035.28263.42.camel@localhost.localdomain>
	<1175704712.15973.35.camel@imap.mvista.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 09:38:32 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> On Sun, 2007-04-01 at 10:43 +0200, Thomas Gleixner wrote:
> > On Sat, 2007-03-31 at 22:23 -0700, akpm@linux-foundation.org wrote:
> > > The patch titled
> > >      clocksource: driver initialize list value
> > > has been added to the -mm tree.  Its filename is
> > >      clocksource-driver-initialize-list-value.patch
> > > 
> > > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > > 
> > > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> > > out what to do about this
> > > 
> > > ------------------------------------------------------
> > > Subject: clocksource: driver initialize list value
> > > From: Daniel Walker <dwalker@mvista.com>
> > > 
> > > Update drivers/clocksource/ with list initialization.
> > 
> > As others pointed out already, can we please have some usefull
> > description why this change is necessary ? i.e. that it is a preparatory
> > patch to simplify the clocksource registration logic.
> > 
> > 	tglx
> 
> I was planning to do it after Andrew release the next -mm then use same
> patch names he has and just submit to him.. I'm not sure what the
> easiest method is, and I'd rather like to avoid re-submitting to LKML ..

Please just send the updated text.  Telling me the name of the patch
into which it is to be pasted is appreciated.
