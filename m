Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbZKMLgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbZKMLgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbZKMLgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:36:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47676 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118AbZKMLgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 06:36:31 -0500
Date: Fri, 13 Nov 2009 12:36:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-mm@kvack.org, gerald.schaefer@de.ibm.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] Allow memory hotplug and hibernation in the same kernel
Message-ID: <20091113113636.GC30880@basil.fritz.box>
References: <20091113105944.GA16028@basil.fritz.box> <20091113200745.33CE.A69D9226@jp.fujitsu.com> <20091113203151.33D1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113203151.33D1.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This is a 2.6.32 candidate.
> 
> 2.6.32?

Well stable at least. But it's simple enough and fixes an obvious
problem and in fact a regression (old kernels didn't exclude memory hotadd
and hibernation), so it could be even a 2.6.32.0 candidate.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
