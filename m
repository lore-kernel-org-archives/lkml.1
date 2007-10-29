Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbXJ2TsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbXJ2TsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXJ2Tqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:46:39 -0400
Received: from mx30.micromemory.com ([67.95.226.74]:4505 "EHLO
	mail.micromemory.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756634AbXJ2Tqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:46:38 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 15:46:38 EDT
Subject: Re: [PATCH 0/5 v3] Porting RapidIO driver from ppc to powerpc
	architecture and adding memory mapped RapidIO driver.
From: Phil Terry <pterry@micromemory.com>
To: wei.zhang@freescale.com
Cc: galak@kernel.crashing.org, mporter@kernel.crashing.org, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <11854393721520-git-send-email-wei.zhang@freescale.com>
References: <11854393721520-git-send-email-wei.zhang@freescale.com>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 12:38:40 -0700
Message-Id: <1193686720.20377.2.camel@pterry-fc6.micromemory.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: pterry@micromemory.com
X-Return-Path: pterry@micromemory.com
X-Envelope-From: pterry@micromemory.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: pterry@micromemory.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can anyone tell me what the status of these are? What kernel release are
they targetted for? Currently I'm trying to work with 2.6.23 plus these
patches locally.

Cheers
Phil

On Thu, 2007-07-26 at 16:42 +0800, Zhang Wei wrote:
> These patches are the version 3 patches for RapidIO with dts update and some minor fixups.
> 
> These patches are used for supporting RapidIO controllers of Freescale. I ported them from ppc architecture to powerpc architecture and added some new features, such as memory mapped driver.
> 
> [PATCH 1/5] Add the explanation and sample of RapidIO DTS OF-node to the document of booting-without-of.txt file.
> [PATCH 2/5] Add RapidIO OF-node to MPC8641HPCN board dts file.
> [PATCH 3/5] Add the platform device support with RapidIO to MPC8641HPCN platform.
> [PATCH 4/5] Add RapidIO support to powerpc architecture.
> [PATCH 5/5] Add the memory management driver to RapidIO.
> 
> Please see below descriptions of these patches:
> 1. Add the RapidIO driver of-device support.
> 2. Add the RapidIO driver support to MPC8641HPCN board.
> 3. Port the RapidIO from ppc to powerpc architecture.
> 4. Add Memory mapped RapidIO driver.
> 5. Add the support to multi master ports.
> 6. Add a simple bitmap RapidIO space allocator driver.
> 7. Change the RapidIO system size of menuconfig to automatically detection.
> 
> Thanks!
> 
> Best Regards,
> Zhang Wei
> 
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 
> 


