Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbYLCO0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbYLCO0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 09:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYLCO02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 09:26:28 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:55569 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYLCO00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 09:26:26 -0500
Date: Wed, 3 Dec 2008 19:50:00 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sameo@openedhand.com
Subject: Re: linux-next: Tree for December 2 (mfd)
Message-ID: <20081203142000.GC5400@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20081202173101.e2b72437.sfr@canb.auug.org.au> <4935771F.6050500@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4935771F.6050500@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap <randy.dunlap@oracle.com> [2008-12-02 09:57:51]:

> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20081201:
> > 
> > Today's tree fails the powerpc allyesconfig build.
> 
> 
> allyesconfig on x86_64 fails with:
> 
> linux-next-20081202/drivers/mfd/twl4030-core.c:682: undefined reference to `clk_get_rate'
> linux-next-20081202/drivers/mfd/twl4030-core.c:683: undefined reference to `clk_put'

The x86 allyesconfig build of next-20081203 kernel fails with same build
failure.

> 
> 
> -- 
> ~Randy

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
