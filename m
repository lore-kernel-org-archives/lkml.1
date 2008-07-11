Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYGKMkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYGKMkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYGKMkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:40:11 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:25806 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYGKMkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:40:09 -0400
X-BigFish: VPS-19(zz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh87il43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3UDUI-02-X2G-01
Date: Fri, 11 Jul 2008 14:39:55 +0200
From: Robert Richter <robert.richter@amd.com>
To: Gabor Gombas <gombasg@sztaki.hu>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 1/2] x86/pci: renamed: numa.c -> numaq_32.c
Message-ID: <20080711123953.GB7963@erda.amd.com>
References: <1215771521-6848-1-git-send-email-robert.richter@amd.com> <1215771521-6848-2-git-send-email-robert.richter@amd.com> <20080711123001.GC10337@boogie.lpds.sztaki.hu> <20080711123213.GA7963@erda.amd.com> <20080711123436.GD10337@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080711123436.GD10337@boogie.lpds.sztaki.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Jul 2008 12:39:56.0833 (UTC) FILETIME=[399B5110:01C8E353]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.07.08 14:34:36, Gabor Gombas wrote:
> On Fri, Jul 11, 2008 at 02:32:14PM +0200, Robert Richter wrote:
> 
> > > Either fix the filename or just drop it completely.
> > 
> > Next patch in this series. This is only the git-mv.
> 
> Oh, sorry, I just realized that too. But wouldn't it be better to just
> omit the file name?

Maybe. My only intention was to rename the files and keep the rest
including the comments as it is.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

