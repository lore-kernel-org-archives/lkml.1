Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZAWLHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZAWLHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZAWLHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:07:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33799 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbZAWLHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:07:25 -0500
Date: Fri, 23 Jan 2009 12:07:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] x86: rename arch/x86/kernel/pci-swiotlb_64.o =>
	pci-swiotlb.o
Message-ID: <20090123110714.GM15188@elte.hu>
References: <1232708176-26379-1-git-send-email-Ian.Campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232708176-26379-1-git-send-email-Ian.Campbell@citrix.com>
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


* Ian Campbell <Ian.Campbell@citrix.com> wrote:

> The file is used for 32 and 64 bit since:
> 
>   commit cfb80c9eae8c7ed8f2ee81090062d15ead51cbe8
>   Author: Jeremy Fitzhardinge <jeremy@goop.org>
>   Date:   Tue Dec 16 12:17:36 2008 -0800
> 
>     x86: unify pci iommu setup and allow swiotlb to compile for 32 bit
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Ingo Molnar <mingo@elte.hu>

applied to tip/core/iommu, thanks Ian!

	Ingo
