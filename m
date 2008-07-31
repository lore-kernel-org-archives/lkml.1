Return-Path: <linux-kernel-owner+w=401wt.eu-S1759156AbYGaVwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156AbYGaVwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756522AbYGaVwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:52:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54570 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbYGaVwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:52:10 -0400
Subject: Re: [PATCH 0/3] dyn_array support #2
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       benh <benh@kernel.crashing.org>
In-Reply-To: <200807302109.21519.yhlu.kernel@gmail.com>
References: <200807291414.55479.yhlu.kernel@gmail.com>
	 <200807300311.48510.yhlu.kernel@gmail.com>
	 <200807301210.31511.yhlu.kernel@gmail.com>
	 <200807302109.21519.yhlu.kernel@gmail.com>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 23:51:48 +0200
Message-Id: <1217541108.8157.108.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 21:09 -0700, Yinghai Lu wrote:
> please check the patches adding dyn_array and nr_irqs #2

Why can't we use a radix tree like powerpc does?

