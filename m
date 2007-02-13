Return-Path: <linux-kernel-owner+w=401wt.eu-S1750914AbXBMRMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750914AbXBMRMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXBMRMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:12:36 -0500
Received: from havoc.gtf.org ([69.61.125.42]:44899 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbXBMRMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:12:35 -0500
Date: Tue, 13 Feb 2007 12:12:33 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: "Martin A. Fink" <fink@mpe.mpg.de>, linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Message-ID: <20070213171233.GA6798@havoc.gtf.org>
References: <200702121502.17130.fink@mpe.mpg.de> <200702121856.29729.fink@mpe.mpg.de> <20070212190835.20f9b92f@localhost.localdomain> <200702131034.22639.fink@mpe.mpg.de> <20070213112527.59eaa504@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213112527.59eaa504@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 11:25:27AM +0000, Alan wrote:
> > So where is the difference between SATA-I and SATA-II ?
> 
> All physical side if they are on the same controller when you do the
> tests. Mostly latency,

SATA-II is a highly confusing marketing term.  It is /not/ a technical
term.

In some cases there are NO differences between SATA-I and SATA-II.  You
can find 1.5Gbps non-NCQ-supporting devices claiming SATA-II.

Similarly, there is no "SATA version" word in the IDENTIFY DEVICE page,
like there are "ATA version" words.

	Jeff



