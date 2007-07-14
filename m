Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbXGNHtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbXGNHtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 03:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXGNHtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 03:49:15 -0400
Received: from www.osadl.org ([213.239.205.134]:47690 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751920AbXGNHtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 03:49:14 -0400
Subject: Re: [PATCH 5/7] ICH Force HPET: ICH5 quirk to force detect enable
From: Thomas Gleixner <tglx@linutronix.de>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46987CAD.9020209@shaw.ca>
References: <fa.GJG5uLURdrisg2rJw413ItLjGTg@ifi.uio.no>
	 <46987CAD.9020209@shaw.ca>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 09:49:10 +0200
Message-Id: <1184399350.12353.334.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 01:35 -0600, Robert Hancock wrote:
> According to some reports, and a quick test I did on my laptop, this 
> same method appears to work on the ICH4 chipset, even though the HPET is 
> not documented on that chipset. Does Intel have any info on HPET support 
> on ICH4 and whether there's any reason we should not force enable it 
> there as well?

There is a patch for ICH4 in my hrt queue:

http://www.tglx.de/projects/hrtimers/

	tglx


