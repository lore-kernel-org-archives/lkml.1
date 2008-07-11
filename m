Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYGKMaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYGKMaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbYGKMaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:30:05 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:47732 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbYGKMaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:30:04 -0400
Date: Fri, 11 Jul 2008 14:30:01 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 1/2] x86/pci: renamed: numa.c -> numaq_32.c
Message-ID: <20080711123001.GC10337@boogie.lpds.sztaki.hu>
References: <1215771521-6848-1-git-send-email-robert.richter@amd.com> <1215771521-6848-2-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215771521-6848-2-git-send-email-robert.richter@amd.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri, Jul 11, 2008 at 12:18:40PM +0200, Robert Richter wrote:

> --- /dev/null
> +++ b/arch/x86/pci/numaq_32.c
> @@ -0,0 +1,178 @@
> +/*
> + * numa.c - Low-level PCI access for NUMA-Q machines
> + */
> +

Either fix the filename or just drop it completely.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
