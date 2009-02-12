Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbZBLALe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbZBLALe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 19:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZBLALZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 19:11:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:39622 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZBLALY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 19:11:24 -0500
Subject: Re: [PATCH] vmalloc: Add __get_vm_area_caller()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090211144509.d22feeb8.akpm@linux-foundation.org>
References: <20090211044854.969CEDDDA9@ozlabs.org>
	 <20090211171804.7021.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090211144509.d22feeb8.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 11:11:04 +1100
Message-Id: <1234397464.29851.20.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-11 at 14:45 -0800, Andrew Morton wrote:
> On Wed, 11 Feb 2009 17:22:47 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > I want to put into powerpc-next patches relying into that, so if the
> > > patch is ok with you guys, can I stick it in powerpc.git ?
> > 
> > hm.
> > Generally, all MM patch should merge into -mm tree at first.
> > but I don't think this patch have conflict risk. 
> > 
> > Andrew, What do you think?
> 
> We can sneak it into mainline later in the week?

That would be best.

Cheers,
Ben.


