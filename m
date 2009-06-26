Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbZFZCKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbZFZCKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 22:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZFZCKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 22:10:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36650 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbZFZCKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 22:10:43 -0400
Date: Thu, 25 Jun 2009 19:08:54 -0700
From: Chris Wright <chrisw@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, fenghua.yu@intel.com,
       akpm@linux-foundation.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
	Mapping Support
Message-ID: <20090626020854.GG28176@x200.localdomain>
References: <20090625003841.GA12226@linux-os.sc.intel.com> <20090625095643F.fujita.tomonori@lab.ntt.co.jp> <20090625041605.GA9330@linux-os.sc.intel.com> <20090625134827W.fujita.tomonori@lab.ntt.co.jp> <1245913886.17089.91.camel@macbook.infradead.org> <1245966743.30355.42.camel@macbook.infradead.org> <20090625234342.GD28176@x200.localdomain> <alpine.LFD.2.01.0906251835060.3605@localhost.localdomain> <20090626015205.GE28176@x200.localdomain> <alpine.LFD.2.01.0906251858540.3605@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906251858540.3605@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> Ok. Sounds like what I want is to get this patch through the ia64 people, 
> after it has gotten some testing there. Since ia64 is where the current 
> kernel fails anyway, that sounds like the motivation will be there too.

Yup, I agree.

thanks,
-chris
