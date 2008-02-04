Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYBDIYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYBDIYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 03:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbYBDIYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 03:24:12 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:14821 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbYBDIYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 03:24:10 -0500
X-Trace: 658739354/mk-filter-1.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.80.9
X-SBRS: None
X-RemoteIP: 81.1.80.9
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CANBZpkdRAVAJ/2dsb2JhbACBWKkC
Subject: Re: [PATCH] SH/Dreamcast - fix regressions, whitespace and memory
	leaks in Maple Bus driver
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh <linux-sh@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
In-Reply-To: <20080204011034.GA22021@linux-sh.org>
References: <1202068847.6262.7.camel@localhost.localdomain>
	 <20080204011034.GA22021@linux-sh.org>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 08:23:44 +0000
Message-Id: <1202113424.6489.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-04 at 10:10 +0900, Paul Mundt wrote:
> On Sun, Feb 03, 2008 at 08:00:47PM +0000, Adrian McMenamin wrote:
> > From: Adrian McMenamin
> > 
> This is useless if you are submitting the patch, especially if you're
> missing a mail address.
> 

>From Documentation/SubmittingPatches

The canonical patch message body contains the following:
  * 
  *   - A "from" line specifying the patch author.
  * 


> > This patch fixes the regression noted here:
> > http://lkml.org/lkml/2008/1/26/189 as well as whitespace issues in the
> > previous commit of this driver and the memory leaks noted here:
> > http://lkml.org/lkml/2008/2/2/143 (as well as one or two other minor
> > cleanups).
> > 
> The subject notes 3 specific things that are being addressed, but you've
> rolled this all in to one patch which makes it utterly impossible to
> figure out what you're actually fixing. At the very least, split this in
> to 3 different patches, each dealing with one of the things noted in the
> subject. The fact that regressions is plural also suggests you may want
> to split this down in to smaller patches that deal with specific
> regressions if they are not directly related.
> 

What would be the point of submitting patches of broken code just to
remove the whitespace your previous commit added to all the lines?


> > Signed off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> > 
> Do not invent new sign-off tags, see Documentation/SubmittingPatches.
> Scripts do end up having to parse this stuff.


Yes, sorry for that.

