Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbYIVQMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbYIVQMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYIVQMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:12:12 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43250 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYIVQML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:12:11 -0400
Subject: Re: Re: Re: [PATCH 9/13] memcg: lookup page cgroup (and remove
	pointer from struct page)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       xemul@openvz.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <32459434.1222099038142.kamezawa.hiroyu@jp.fujitsu.com>
References: <1222098450.8533.41.camel@nimitz>
	 <1222095177.8533.14.camel@nimitz>
	 <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080922201206.e73d9ce6.kamezawa.hiroyu@jp.fujitsu.com>
	 <31600854.1222096483210.kamezawa.hiroyu@jp.fujitsu.com>
	 <32459434.1222099038142.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 09:10:50 -0700
Message-Id: <1222099850.8533.60.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-23 at 00:57 +0900, kamezawa.hiroyu@jp.fujitsu.com wrote:
> I'll add FLATMEM/SPARSEMEM support later. Could you wait for a while ?
> Because we have lookup_page_cgroup() after this, we can do anything.

OK, I'll stop harassing for the moment, and take a look at the cache. :)

-- Dave

