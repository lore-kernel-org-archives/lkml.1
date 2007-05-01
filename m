Return-Path: <linux-kernel-owner+w=401wt.eu-S965472AbXEAHgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472AbXEAHgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 03:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965528AbXEAHgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 03:36:33 -0400
Received: from phoenix.bawue.net ([193.7.176.60]:52916 "EHLO mail.bawue.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965472AbXEAHgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 03:36:31 -0400
Date: Tue, 1 May 2007 09:36:24 +0200
From: Joerg Sommrey <jo@sommrey.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21: pmtmr losing time
Message-ID: <20070501073624.GA6835@sommrey.de>
Mail-Followup-To: Joerg Sommrey <jo@sommrey.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20070430125200.GA5379@sommrey.de> <1177950216.5791.241.camel@localhost.localdomain> <20070430163944.GA29206@sommrey.de> <1177969115.5791.244.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177969115.5791.244.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 11:38:34PM +0200, Thomas Gleixner wrote:
> On Mon, 2007-04-30 at 18:39 +0200, Joerg Sommrey wrote:
> > Here it is.  Maybe this problem is related to the usage of the
> > "experimental" amd76x_pm module?
> 
> Can you please verify what happens w/o that module ?
> 
After rebooting the problem vanished for now.  It first appeared after
an uptime of about 3 days.  I'll wait a few days.  If it shows
again, then I'll check without amd76x_pm.

-jo

> Thanks,
> 
> 	tglx
> 
> 

-- 
-rw-r--r-- 1 jo users 62 2007-05-01 01:11 /home/jo/.signature
