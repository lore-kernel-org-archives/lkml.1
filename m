Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZEEKWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZEEKWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 06:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZEEKVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 06:21:52 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:29072 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753975AbZEEKVv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 06:21:51 -0400
X-BigFish: VPS-20(zz1432R98dR1805M936fJzz1202hzzz32i6bh15fn)
X-WSS-ID: 0KJ6240-02-U9X-01
Date: Tue, 5 May 2009 12:21:37 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg KH <greg@kroah.com>
CC: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] amd-iommu: fix iommu flag masks
Message-ID: <20090505102137.GD4059@amd.com>
References: <1241431907-30225-1-git-send-email-joerg.roedel@amd.com> <20090504230147.GA10086@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090504230147.GA10086@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 05 May 2009 10:21:38.0179 (UTC) FILETIME=[4652B530:01C9CD6B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 04:01:47PM -0700, Greg KH wrote:
> On Mon, May 04, 2009 at 12:11:47PM +0200, Joerg Roedel wrote:
> > Impact: fix initialization of iommu flags
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> This patch does not look to be in Linus's tree yet.
> 
> What is the plan for it to get there?

I sent it to Ingo for 2.6.30. I think it will be upstream soon.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

