Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbZFYRcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbZFYRcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZFYRcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:32:14 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2307 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbZFYRcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:32:13 -0400
Subject: Re: [PATCH] MAINTAINERS: STARFIRE/DURALAN update
From: Joe Perches <joe@perches.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ion Badulescu <ionut@badula.org>, NetDev <netdev@vger.kernel.org>
In-Reply-To: <4A43B060.30904@garzik.org>
References: <1245946630.395.37.camel@Joe-Laptop.home>
	 <4A43B060.30904@garzik.org>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 10:31:14 -0700
Message-Id: <1245951074.395.78.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 13:14 -0400, Jeff Garzik wrote:
> Joe Perches wrote:
> > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index fa2a16d..218126a 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5533,8 +5533,8 @@ F:	drivers/staging/
> >  
> >  STARFIRE/DURALAN NETWORK DRIVER
> >  P:	Ion Badulescu
> > -M:	ionut@cs.columbia.edu
> > -S:	Maintained
> > +M:	ionut@badula.org
> > +S:	Odd Fixes
> >  F:	drivers/net/starfire*
> >  
> >  STARMODE RADIO IP (STRIP) PROTOCOL DRIVER
> 
> This change needs a better explanation, and should be CC'd to netdev 
> since it relates to network drivers.

His old email address is invalid.

I looked up his name in git log
and found a single commit, emailed him
and asked.

His new email is on the cc list.


