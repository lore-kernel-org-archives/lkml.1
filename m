Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbYCXXLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbYCXXLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbYCXXLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:11:45 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:53032 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199AbYCXXLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:11:44 -0400
X-Trace: 685371150/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQFAGjS50dRAVlC/2dsb2JhbACBW6ZX
Subject: Re: [PATCH] 2/3 mtd: add support for flash on the SEGA Dreamcast
	Visual Memory Unit
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>
In-Reply-To: <20080324141043.GB2899@logfs.org>
References: <1206211147.6324.48.camel@localhost.localdomain>
	 <20080322185600.GE19347@logfs.org>
	 <1206207805.6324.13.camel@localhost.localdomain>
	 <1206209035.6324.29.camel@localhost.localdomain>
	 <20080322183200.GD19347@logfs.org>
	 <1206211147.6324.48.camel@localhost.localdomain>
	 <20080324020832.GA13935@linux-sh.org>
	 <1206360384.6283.11.camel@localhost.localdomain>
	 <20080324132101.GA2899@logfs.org>
	 <1206367120.6283.15.camel@localhost.localdomain>
	 <20080324141043.GB2899@logfs.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 24 Mar 2008 23:11:21 +0000
Message-Id: <1206400281.10173.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-24 at 15:10 +0100, Jörn Engel wrote:
> On Mon, 24 March 2008 13:58:40 +0000, Adrian McMenamin wrote:
> > 
> > Tempting as it is to continue the war, discretion will be the better
> > part of valour here and I will give you the last word.
> > 
> > Of course I don't mind you sending patches. Indeed it would be very
> > helpful and generous of you to do so.
> 
> Good.  The first four shouldn't change any behaviour.  Number five flips
> positive error returns into negative ones.  I believe the old behaviour
> is a bug.  Worth a second look to make sure.
> 
> All five patches are attached.  Hope that doesn't cause any problems.

Just to keep you informed...

I have patched and tested four of these without any problem.

I haven't patched with the return/goto one as I think that needs more
work.

Other patches (the ones that have a chance of working) will be tested in
due course.

