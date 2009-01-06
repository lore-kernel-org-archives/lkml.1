Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbZAFO1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbZAFO1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 09:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZAFO1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 09:27:34 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:58222 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbZAFO1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 09:27:33 -0500
X-BigFish: VPS-41(zz1432R98dR168aJ1805M179dR936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KD205B-04-3Q4-01
Date: Tue, 6 Jan 2009 15:27:13 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AMD IOMMU: remove unnecessary ifdef
Message-ID: <20090106142713.GC18453@amd.com>
References: <20090106001704O.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090106001704O.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 06 Jan 2009 14:27:13.0131 (UTC) FILETIME=[DDE1B3B0:01C9700A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 12:17:09AM +0900, FUJITA Tomonori wrote:
> Hmm, why do we need this ifdef? We should avoid it, I think.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] AMD IOMMU: remove unnecessary ifdef
> 
> We try to avoid this type of ifdef and we can safely remove this
> ifdef.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Applied to iommu/amd, thanks.

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

