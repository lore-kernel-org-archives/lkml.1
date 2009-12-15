Return-Path: <linux-kernel-owner+w=401wt.eu-S934140AbZLOX63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140AbZLOX63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758647AbZLOX60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:58:26 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39891 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042AbZLOX6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:58:24 -0500
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode drive -v2
From: Keith Mannthey <kmannth@us.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20091215151213.8b357858.randy.dunlap@oracle.com>
References: <1260907788.6521.10.camel@keith-laptop>
	 <20091215151213.8b357858.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Tue, 15 Dec 2009 15:58:22 -0800
Message-Id: <1260921502.6521.14.camel@keith-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 15:12 -0800, Randy Dunlap wrote:
> On Tue, 15 Dec 2009 12:09:48 -0800 Keith Mannthey wrote:
> 
> > diff -urN linux-2.6.32/drivers/misc/ibmrtl/rtl.h linux-2.6.32-rtl/drivers/misc/ibmrtl/rtl.h
> > --- linux-2.6.32/drivers/misc/ibmrtl/rtl.h	1969-12-31 16:00:00.000000000 -0800
> > +++ linux-2.6.32-rtl/drivers/misc/ibmrtl/rtl.h	2009-12-11 10:24:23.000000000 -0800
> > @@ -0,0 +1,27 @@
> > +#include <linux/io.h>
> > +
> > +/* The RTL table looks something like
> 
> Is this documented somewhere?  (besides here ;)

Sorry not at this time to my knowledge. 

Thanks for the review and the comment suggestions. I will integrate
them. 

Thanks, 
  Keith Mannthey
  LTC Real-Time 

