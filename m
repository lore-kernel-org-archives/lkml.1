Return-Path: <linux-kernel-owner+w=401wt.eu-S934842AbZLPIks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934842AbZLPIks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761828AbZLPIkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:40:47 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41865 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbZLPIkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:40:46 -0500
Date: Wed, 16 Dec 2009 14:10:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/4] memcg: extract mem_group_usage() from
 mem_cgroup_read()
Message-ID: <20091216084037.GA4397@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <cover.1260571675.git.kirill@shutemov.name>
 <c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kirill A. Shutemov <kirill@shutemov.name> [2009-12-12 00:59:17]:

> Helper to get memory or mem+swap usage of the cgroup.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

Looks like a good cleanup to me!

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
-- 
	Balbir
