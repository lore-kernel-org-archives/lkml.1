Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbZBYLMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbZBYLMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZBYLMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:12:34 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:52027 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755856AbZBYLMd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:12:33 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 06:12:33 EST
X-BigFish: VPS-27(zz1432R98dR1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KFMBRI-03-7Y6-01
Date: Wed, 25 Feb 2009 11:57:16 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, iommu@lists.linux-foundation.org,
       johannes@sipsolutions.net
Subject: Re: [PATCH 0/16] DMA-API debugging facility v3
Message-ID: <20090225105716.GK8751@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com> <1235547199.519.36.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1235547199.519.36.camel@macbook.infradead.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 25 Feb 2009 10:57:16.0863 (UTC) FILETIME=[D2933CF0:01C99737]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 04:33:19PM +0900, David Woodhouse wrote:
> Where we complain about a discrepancy between unmap/sync and the
> original mapping, it can sometimes be useful to see the backtrace of the
> code which _mapped_ the region originally.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
> Untested. Builds though. Thanks Johannes for pointing me at an example.

Cool stuff. Thanks. I will give it a test and apply it to my tree.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

