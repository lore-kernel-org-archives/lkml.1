Return-Path: <linux-kernel-owner+w=401wt.eu-S1759122AbZLJACg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbZLJACg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758966AbZLJACa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:02:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53693 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759072AbZLJACT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:02:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Dec 2009 08:59:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] [TRIVIAL] memcg: fix memory.memsw.usage_in_bytes for
 root cgroup
Message-Id: <20091210085929.56c63eb2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1260373738-17179-1-git-send-email-kirill@shutemov.name>
References: <1260373738-17179-1-git-send-email-kirill@shutemov.name>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Dec 2009 17:48:58 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> We really want to take MEM_CGROUP_STAT_SWAPOUT into account.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: stable@kernel.org

Thanks.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

