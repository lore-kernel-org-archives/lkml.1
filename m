Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbZEGOht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbZEGOht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZEGOhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:37:40 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:24714
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754007AbZEGOhj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:37:39 -0400
X-BigFish: VPS-24(zz1432R98dR1805M936fJzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KJA3A5-03-FJ1-01
Date: Thu, 7 May 2009 16:37:18 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, mingo@redhat.com, airlied@linux.ie
Subject: Re: IOMMU and graphics cards
Message-ID: <20090507143717.GK4059@amd.com>
References: <20090507100114.GF4059@amd.com> <1241691721.3531.73.camel@macbook.infradead.org> <20090507121535.GH4059@amd.com> <20090507215933K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090507215933K.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 May 2009 14:37:18.0393 (UTC) FILETIME=[52A11A90:01C9CF21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 09:59:19PM +0900, FUJITA Tomonori wrote:
> 
> Have you already discussed this issue with distribution people?
> 
> I'm not sure if they would just disable the IOMMU. They want it for
> exotic virtualization features?

Not yet. But thats true for distributions using KVM as their
virtualization technology.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

