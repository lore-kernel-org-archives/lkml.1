Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbZAIFfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbZAIFfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 00:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZAIFfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 00:35:02 -0500
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:51925 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbZAIFfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 00:35:00 -0500
Date: Fri, 9 Jan 2009 11:04:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, menage@google.com
Subject: Re: [RFC][PATCH 3/4] memcg: fix for mem_cgroup_hierarchical_reclaim
Message-ID: <20090109053458.GE9737@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp> <20090108191501.dc469a51.nishimura@mxp.nes.nec.co.jp> <39822.10.75.179.62.1231412881.squirrel@webmail-b.css.fujitsu.com> <20090109100830.3e9c90e0.kamezawa.hiroyu@jp.fujitsu.com> <20090109115103.e17b18f2.nishimura@mxp.nes.nec.co.jp> <20090109120950.09f55ce5.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090109120950.09f55ce5.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-09 12:09:50]:

> Ok, please go ahead.
> 
> Maybe create a patch agains "rc1" is better for all your fixes.
> And please ask Andrew to "This is a bugfix and please put into fast-path" 
> 
> -Kame 
>

Agreed and we'll test it thoroughly meanwhile! 

-- 
	Balbir
