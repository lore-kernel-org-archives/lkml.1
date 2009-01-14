Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbZANRwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbZANRwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZANRvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:51:36 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:63215 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbZANRve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:51:34 -0500
X-BigFish: VPS-29(zz1432R98dR1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KDH2X5-04-DF2-01
Date: Wed, 14 Jan 2009 18:51:09 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/16] dma-debug: add hash functions for dma_debug_entries
Message-ID: <20090114175109.GB11842@amd.com>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-4-git-send-email-joerg.roedel@amd.com> <20090113005118.82f5037b.akpm@linux-foundation.org> <20090114114347.GG8625@elte.hu> <20090114093918.e7b0ae46.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090114093918.e7b0ae46.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 14 Jan 2009 17:51:09.0250 (UTC) FILETIME=[AE7B4A20:01C97670]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 09:39:18AM -0800, Andrew Morton wrote:
> 
> Have we previously found bugs by other means which this facility would
> have detected?  I don't recall any...
> 

See for example this bugfix:

http://www.spinics.net/lists/netdev/msg83208.html

The bug was found using the first version of this patchset.

Joerg


-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

