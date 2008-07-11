Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYGKMcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYGKMcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYGKMc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:32:29 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:27029 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbYGKMc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:32:28 -0400
X-BigFish: VPS-19(zz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh87il43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3UDHO-01-3MH-01
Date: Fri, 11 Jul 2008 14:32:14 +0200
From: Robert Richter <robert.richter@amd.com>
To: Gabor Gombas <gombasg@sztaki.hu>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 1/2] x86/pci: renamed: numa.c -> numaq_32.c
Message-ID: <20080711123213.GA7963@erda.amd.com>
References: <1215771521-6848-1-git-send-email-robert.richter@amd.com> <1215771521-6848-2-git-send-email-robert.richter@amd.com> <20080711123001.GC10337@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080711123001.GC10337@boogie.lpds.sztaki.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Jul 2008 12:32:15.0827 (UTC) FILETIME=[26D36230:01C8E352]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.07.08 14:30:01, Gabor Gombas wrote:
> On Fri, Jul 11, 2008 at 12:18:40PM +0200, Robert Richter wrote:
> 
> > --- /dev/null
> > +++ b/arch/x86/pci/numaq_32.c
> > @@ -0,0 +1,178 @@
> > +/*
> > + * numa.c - Low-level PCI access for NUMA-Q machines
> > + */
> > +
> 
> Either fix the filename or just drop it completely.

Next patch in this series. This is only the git-mv.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

