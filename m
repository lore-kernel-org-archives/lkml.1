Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYHHHRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYHHHRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 03:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYHHHRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 03:17:19 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:49161 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYHHHRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 03:17:18 -0400
Date: Fri, 8 Aug 2008 10:00:40 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, x86@kernel.org,
       akpm <akpm@linux-foundation.org>, jdmason@kudzu.us
Subject: Re: [PATCH] pci-calgary: fix function declaration
Message-ID: <20080808070040.GA6931@il.ibm.com>
References: <20080807151455.12b53aa5.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807151455.12b53aa5.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 03:14:55PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> cc: muli@il.ibm.com, jdmason@kudzu.us
> 
> Fix function declaration:
> 
> linux-next-20080807/arch/x86/kernel/pci-calgary_64.c:1353:36: warning: non-ANSI function declaration of function 'get_tce_space_from_tar'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
-- 
Workshop on I/O Virtualization (WIOV '08)
Co-located with OSDI '08, Dec 2008, San Diego, CA
http://www.usenix.org/wiov08
