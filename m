Return-Path: <linux-kernel-owner+w=401wt.eu-S1766981AbXEBRyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766981AbXEBRyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766985AbXEBRyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:54:22 -0400
Received: from emailgw01.pnl.gov ([192.101.109.33]:13269 "EHLO
	emailgw01.pnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766981AbXEBRyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:54:21 -0400
X-Greylist: delayed 3603 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2007 13:54:21 EDT
X-Possible-Spoof: True
X-IronPort-AV: i="4.14,480,1170662400"; 
   d="scan'208"; a="30353026:sNHT30585709"
Subject: Re: Kernel Scalability
From: Kevin Fox <Kevin.Fox@pnl.gov>
To: Rajib Majumder <rajibm2005@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fdb8a7ad0705020556t5015f95fqbd2638dd4636db87@mail.gmail.com>
References: <fdb8a7ad0705020556t5015f95fqbd2638dd4636db87@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 02 May 2007 09:54:17 -0700
Message-Id: <1178124858.10228.83.camel@zathras.emsl.pnl.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are multiple 512 processor altix's in production. :)

Kevin

On Wed, 2007-05-02 at 20:56 +0800, Rajib Majumder wrote:
> Hi,
> 
> I am wondering if 2.4.x/2.6.x kernel is scalable enough to run on
> 8-CPU hardware. Do we have any scalability comparison data between
> 2.4/2.6 kernels and beyond 4-CPU?
> 
> If yes, is the scalablity is near linear?
> 
> Any input is appreciated.
> 
> Thanks
> 
> Rajib
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
