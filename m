Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbYCLXCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbYCLXCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYCLXCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:02:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44626 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYCLXCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:02:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
Date: Thu, 13 Mar 2008 00:01:52 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
References: <200803110014.52985.rjw@sisk.pl> <alpine.DEB.1.00.0803122303430.5088@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.1.00.0803122303430.5088@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803130001.52873.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 12 of March 2008, Christian Kujau wrote:
> On Tue, 11 Mar 2008, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10191
> > Subject		: Treason uncloaked spams syslog with latest git
> > Submitter	: Thomas Gleixner <tglx@linutronix.de>
> > Date		: 2008-03-06 05:47
> > References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0803.0/2444.html
> 
> Dunno if you got this, but this seems to be fixed: 
> http://lkml.org/lkml/2008/3/11/435

Yes, I noticed the patch and updated the Bugzilla entry with a link to it,
but it will be closed when the patch appears in the Linus' tree.

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10207
> > Subject		: INFO: task mount:11202 blocked for more than 120 seconds
> > Submitter	: Christian Kujau <lists@nerdbynature.de>
> > Date		: 2008-03-07 21:32
> > References	: http://lkml.org/lkml/2008/3/7/308
> > 		  http://lkml.org/lkml/2008/3/9/186
> > Handled-By	: David Chinner <dgc@sgi.com>
> 
> FWIW, it has been reported by Chr too: http://lkml.org/lkml/2008/3/12/313

Yes.

> And David could be taken out of the loop, as it seems dm-crypt related 
> (dm-devel@redhat.com is already notified), not XFS related.

The entry has already been updated and Herbert is on its CC list.

Thanks,
Rafael
