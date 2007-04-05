Return-Path: <linux-kernel-owner+w=401wt.eu-S1767335AbXDEVmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767335AbXDEVmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767349AbXDEVmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:42:20 -0400
Received: from anchor-post-36.mail.demon.net ([194.217.242.86]:3037 "EHLO
	anchor-post-36.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767335AbXDEVmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:42:19 -0400
Subject: Re: [PATCH 01/01] New FBDev driver for Intel Vermilion Range
From: Alan Hourihane <alanh@fairlite.demon.co.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200704052138.08897.arnd@arndb.de>
References: <1175769886.10382.29.camel@localhost>
	 <200704052138.08897.arnd@arndb.de>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 22:42:16 +0100
Message-Id: <1175809336.10105.54.camel@jetpack.demon.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 21:38 +0200, Arnd Bergmann wrote:
> On Thursday 05 April 2007, Alan Hourihane wrote:
> > @@ -0,0 +1,405 @@
> > +/*  
> > + * Copyright (c) Intel Corp. 2007.
> > + * All Rights Reserved.
> > + *
> 
> Saying 'All Rights Reserved' is usually considered the opposite of
> licensing your code as GPL. I suppose you need to remove that.

Arnd, 

Thanks for your comments, and I'll review and make appropriate changes
as you've suggested.

As for the above, I've noticed that drivers/video/epson1355fb.c also has
this wording and is under the GPL. 

Alan.

