Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZLCB61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZLCB61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 20:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZLCB61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 20:58:27 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:48339 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZLCB60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 20:58:26 -0500
Date: Thu, 3 Dec 2009 07:28:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/24] memcg: rename and export
 try_get_mem_cgroup_from_page()
Message-ID: <20091203015827.GG3545@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091202031231.735876003@intel.com>
 <20091202043046.127781753@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091202043046.127781753@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wu Fengguang <fengguang.wu@intel.com> [2009-12-02 11:12:50]:

> So that the hwpoison injector can get mem_cgroup for arbitrary page
> and thus know whether it is owned by some mem_cgroup task(s).
> 
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> CC: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> CC: Balbir Singh <balbir@linux.vnet.ibm.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Sorry for the delay in reviewing, I am attending a conference this
week. I'll try and get to them soon.

-- 
	Balbir
