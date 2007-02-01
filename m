Return-Path: <linux-kernel-owner+w=401wt.eu-S1030517AbXBAAjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030517AbXBAAjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030511AbXBAAjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:39:18 -0500
Received: from www.osadl.org ([213.239.205.134]:59962 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030517AbXBAAjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:39:17 -0500
Subject: Re: 2.6.20-rc6 ramdisk problem
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Robert Hancock <hancockr@shaw.ca>
Cc: michal.k.k.piotrowski@gmail.com,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <45C130DC.90905@shaw.ca>
References: <fa.nr9vhGrVS5zmSNQEe1vQ/Ktii9w@ifi.uio.no>
	 <45C12C3E.6010902@shaw.ca>
	 <1170288386.29240.234.camel@localhost.localdomain> <45C130DC.90905@shaw.ca>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 01:40:08 +0100
Message-Id: <1170290408.29240.252.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 18:14 -0600, Robert Hancock wrote:
> > So either #1 or #2 should have failed in the first place. Failing in #3
> > is definitely a BUG in #1 or #2.
> > 
> > How does your advise help to fix that BUG ? Ignoring it by using
> > something else ?
> 
> Yes, there is likely a bug here of some sort. However, that doesn't 
> change the fact that ramdisks are sub-optimal for most uses.

You still did not answer my question: 
How does this deep insight help us to track down that BUG ?

Michal is actively testing the kernel and provides extremly useful
information about problems. He pointed out a bug and we want to fix it.
Adding special instructions, which are appropriate for a LUG
mailinglist, does us not get any further.

	tglx


