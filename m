Return-Path: <linux-kernel-owner+w=401wt.eu-S1761513AbYFSQCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513AbYFSQCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 12:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYFSQC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 12:02:29 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:14167 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbYFSQC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 12:02:28 -0400
X-BigFish: VPS-43(zz1432R98dR4015M62a3L7efV1805Mzz10d3izzz32i6bh87i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K2PWJO-01-ZYZ-01
Date: Thu, 19 Jun 2008 18:02:16 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] x86/pci: Renaming k8-bus_64.c to amd_bus.c
Message-ID: <20080619160216.GE10019@erda.amd.com>
References: <20080603072550.GR23679@erda.amd.com> <1213294763-19566-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1213294763-19566-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 19 Jun 2008 16:02:16.0906 (UTC) FILETIME=[D890F2A0:01C8D225]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.06.08 20:19:22, Robert Richter wrote:
> The name fits better since this is code not only for K8.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/pci/Makefile_64 |    2 +-
>  arch/x86/pci/amd_bus.c   |  528 ++++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/pci/k8-bus_64.c |  528 ----------------------------------------------
>  3 files changed, 529 insertions(+), 529 deletions(-)
>  create mode 100644 arch/x86/pci/amd_bus.c
>  delete mode 100644 arch/x86/pci/k8-bus_64.c

I accidentally resent the patches, please igore.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

