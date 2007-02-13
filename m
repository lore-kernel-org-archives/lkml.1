Return-Path: <linux-kernel-owner+w=401wt.eu-S1751301AbXBMMId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbXBMMId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 07:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbXBMMId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 07:08:33 -0500
Received: from lazybastard.de ([212.112.238.170]:37772 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbXBMMIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 07:08:32 -0500
Date: Tue, 13 Feb 2007 12:04:52 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: "Martin A. Fink" <fink@mpe.mpg.de>
Cc: Matthias Schniedermeyer <ms@citd.de>, linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Message-ID: <20070213120452.GB12383@lazybastard.org>
References: <200702121502.17130.fink@mpe.mpg.de> <200702131025.15964.fink@mpe.mpg.de> <45D19014.5080900@citd.de> <200702131129.19270.fink@mpe.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200702131129.19270.fink@mpe.mpg.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 February 2007 11:29:18 +0100, Martin A. Fink wrote:
> 
> Please Read Carefully! I talk about flash disk, not normal harddisks. There 
> are no mechanical parts in flash disks, only flash memory. And therefore 
> 48MB/s is excellent (compared to all other available disks)
> 
> [...]
> 
> Well. The testdrive has 27GB. The final drive will have 225 GB. And there will 
> be 3 cameras and thus 3 disks. This means we talk about 140 MB/s for around 
> 90 minutes.

Do you have any numbers on the performance for the final drive?  Single
flash chips are relatively slow, the high bandwidth is usually achieved
by writing in parallel to several of them.  With the bigger drive you
get more chips and the manufacturer could run more of them in parallel.

Jörn

-- 
With a PC, I always felt limited by the software available. On Unix,
I am limited only by my knowledge.
-- Peter J. Schoenster
