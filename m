Return-Path: <linux-kernel-owner+w=401wt.eu-S1762231AbXEOItG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762231AbXEOItG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbXEOIs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:48:56 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:33959 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380AbXEOIs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:48:56 -0400
Date: Tue, 15 May 2007 11:48:40 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Valdis.Kletnieks@vt.edu
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow kernel module exclusion on load
Message-ID: <20070515084840.GB16243@localdomain>
References: <20070513132517.GA14038@localdomain> <11088.1179174201@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11088.1179174201@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 04:23:21PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 13 May 2007 16:25:17 +0300, Dan Aloni said:
> > Kernel developers might find it useful for quickly getting out from some 
> > rough debugging scenarios.
> > 
> > Signed-off-by: Dan Aloni <da-x@monatomic.org>
> 
> I think I (and everybody else who tests kernels with 3rd-party binary or
> out-of-tree modules) owe you a beer-equivalent. ;)
> 

Thanks, just hold that thought until OLS2007, where there's beer :)

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
