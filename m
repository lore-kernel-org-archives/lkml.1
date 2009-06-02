Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbZFBI1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbZFBI1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbZFBI1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:27:37 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:46542 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758186AbZFBI1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:27:35 -0400
X-SpamScore: -14
X-BigFish: VPS-14(z34a4jz1432R98dR1805M873fnzz1202hzzz32i6bh17ch43j)
X-WSS-ID: 0KKLRHH-04-6L2-01
Date: Tue, 2 Jun 2009 10:27:15 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] dma-debug: add variables and checks for driver
	filter
Message-ID: <20090602082714.GK4062@amd.com>
References: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com> <1243523971-12681-2-git-send-email-joerg.roedel@amd.com> <20090601145502.0653f979.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090601145502.0653f979.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Jun 2009 08:27:15.0351 (UTC) FILETIME=[EF534270:01C9E35B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 02:55:02PM -0700, Andrew Morton wrote:
> On Thu, 28 May 2009 17:19:28 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch adds the state variables for the driver filter and a function
> > to check if the filter is enabled and matches to the current device. The
> > check is built into the err_printk function.
> > 
> 
> The path by which lib/dma-debug.c patches get into mainline seems to
> be largely random.  Is it a dwmw2 tree?  An Ingo tree?  A Joerg tree? -mm?

When I addresses your comment I will repost and send it to Ingo later
on. He will send it upstream. At least thats the current plan :-)

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

