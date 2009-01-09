Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZAIObI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZAIObI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 09:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbZAIOaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 09:30:55 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:27793 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbZAIOay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 09:30:54 -0500
X-BigFish: VPS-40(zz1432R62a3L98dR936eQ4015M1805Mzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KD7KB4-01-HGA-01
Date: Fri, 9 Jan 2009 15:30:43 +0100
From: Robert Richter <robert.richter@amd.com>
To: Carl Love <cel@us.ibm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev <cbe-oss-dev@ozlabs.org>
Subject: Re: [Patch 0/3] Overview, OProfile SPU event profiling support for
	IBM Cell processor
Message-ID: <20090109143042.GU15411@erda.amd.com>
References: <1228177106.6509.285.camel@carll-linux-desktop> <20090108154835.GQ15411@erda.amd.com> <1231460791.6621.54.camel@carll-linux-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1231460791.6621.54.camel@carll-linux-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Jan 2009 14:30:43.0257 (UTC) FILETIME=[DA5DA290:01C97266]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.01.09 16:26:31, Carl Love wrote:
> >  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git cell
> > 
> > The patches did not apply cleanly. I had to change the path to
> > arch/powerpc/include/asm/, fix cell/pr_util.h and did some whitespace
> > cleanups. Please run your tests on the cell branch.

Thanks Carl, could you also test the 'next' branch on your
architecture, please? This is the latest version of patches to go
upstream (containing your patches also).

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

