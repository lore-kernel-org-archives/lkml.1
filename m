Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZI2JKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZI2JKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZI2JJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:09:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:34486 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbZI2JJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 05:09:58 -0400
Date: Tue, 29 Sep 2009 11:10:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] staging/et131x:  adding __init/__exit macros
In-Reply-To: <200909290134.15295.PeterHuewe@gmx.de>
Message-ID: <alpine.LSU.2.00.0909291107410.9280@wotan.suse.de>
References: <200909290134.15295.PeterHuewe@gmx.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009, Peter Huewe wrote:

> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of ./staging/et131x/et131x_initpci.c
> 
> Greg, please have a look at the small patch and either pull it through
> your staging tree, or please ack' it so Jiri can pull it through the trivial tree.

Greg -- I'd prefer you taking trivial staging fixes through yoru tree, as 
I expect we'll be conflicting soon due to the speed of changes in staging 
area, if you don't have any objections.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
