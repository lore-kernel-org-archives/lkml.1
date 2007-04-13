Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbXDMQOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbXDMQOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbXDMQOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:14:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37764 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754039AbXDMQOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:14:40 -0400
Date: Fri, 13 Apr 2007 17:17:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Christopher S. Aker" <caker@theshore.net>,
       "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
Message-ID: <20070413171727.6a54d80e@the-village.bc.nu>
In-Reply-To: <461F9ABE.6060709@oracle.com>
References: <461E55C6.1030905@theshore.net>
	<20070412172845.58bfeff5@the-village.bc.nu>
	<20070412164251.GC11736@ti88.telemetry-investments.com>
	<p73ps697agf.fsf@bingen.suse.de>
	<461EE95A.3090600@theshore.net>
	<20070412193838.ea98238b.randy.dunlap@oracle.com>
	<461EF1A1.3070102@theshore.net>
	<20070413115526.69e61016@the-village.bc.nu>
	<p73d528799k.fsf@bingen.suse.de>
	<461F9ABE.6060709@oracle.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Here's a patch. It just doesn't do any formatting for the pipe case.

I don't see a reaosn for removing the formatting features. There are ways
that can usefully be used, although not many. It's also messier than the
patch I posted while less functional IMHO.

Alan
