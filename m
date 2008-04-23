Return-Path: <linux-kernel-owner+w=401wt.eu-S934203AbYDWCug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203AbYDWCug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 22:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbYDWCu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 22:50:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47619 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYDWCu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 22:50:27 -0400
Date: Wed, 23 Apr 2008 11:50:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: remove redundant initialization in
 mem_cgroup_create()
Message-Id: <20080423115041.c918091d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <480E9E52.4080905@cn.fujitsu.com>
References: <480E9E52.4080905@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008 10:26:26 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> *mem has been zeroed, that means mem->info has already
> been filled with 0.
> 
maybe my mistake :(

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

