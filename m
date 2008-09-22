Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYIVRuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYIVRuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYIVRt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:49:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37900 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYIVRtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:49:55 -0400
Date: Mon, 22 Sep 2008 19:49:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, muli@il.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] export iommu_area_reserve helper funciton
Message-ID: <20080922174939.GD10535@elte.hu>
References: <20080922223353K.fujita.tomonori@lab.ntt.co.jp> <20080922144849.GB27956@elte.hu> <20080923011448M.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923011448M.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Subject: [PATCH] x86: remove unused set_bit_string
> 
> "export iommu_area_reserve helper funciton" patch converted all the 
> users of set_bit_string, GART, Calgary and AMD IOMMU drivers, to use 
> iommu_area_reserve helper function. Now we can remove unused 
> set_bit_string function.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

applied to tip/x86/iommu, thanks!

	Ingo
