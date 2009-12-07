Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbZLGCB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbZLGCB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 21:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbZLGCBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 21:01:54 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:29756 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184AbZLGCBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 21:01:54 -0500
Date: Sun, 6 Dec 2009 19:01:57 -0700
From: Alex Chiang <achiang@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Li, Haicheng" <haicheng.li@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC] print symbolic page flag names in bad_page()
Message-ID: <20091207020157.GA394@ldl.fc.hp.com>
References: <20091204212606.29258.98531.stgit@bob.kio> <20091206034636.GA7109@localhost> <20091206230016.GA18989@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206230016.GA18989@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org>:
> > So how about this patch?
> 
> I like it. Decoding the flags by hand is always a very unpleasant experience.
> Bonus: dump_page can be called from kgdb too.

This is fine by me too.

Thanks,
/ac

