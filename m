Return-Path: <linux-kernel-owner+w=401wt.eu-S1762866AbYBNXTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762866AbYBNXTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbYBNXT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:19:28 -0500
Received: from lixom.net ([66.141.50.11]:34138 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326AbYBNXT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:19:27 -0500
Date: Thu, 14 Feb 2008 17:21:52 -0600
From: Olof Johansson <olof@lixom.net>
To: Becky Bruce <becky.bruce@freescale.com>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4]: Respun LMB patches.
Message-ID: <20080214232152.GB15724@lixom.net>
References: <20080213.170938.34536425.davem@davemloft.net> <38133B3C-75A2-4465-9484-7BF8E7E85D1D@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38133B3C-75A2-4465-9484-7BF8E7E85D1D@freescale.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 02:58:22PM -0600, Becky Bruce wrote:

> Thanks for picking up the patches from Kumar and myself and fitting  
> them into your series - this is much appreciated.  FYI, I applied the  
> entire patch series to my local tree and test-booted both mpc8641 and  
> mpc8568mds and both build and boot cleanly. I also built pasemi and  
> ebony, those build cleanly as well.

pasemi_defconfig boots happily on my boards here. I've kicked off my
"build all powerpc defconfigs" script while I leave the house for a
couple of hours, but as others have said, no problems are expected...


-Olof
