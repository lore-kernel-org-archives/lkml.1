Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbYLEDur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbYLEDur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbYLEDuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:50:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44535 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYLEDuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:50:39 -0500
Date: Fri, 5 Dec 2008 12:49:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [memcg BUG ?] failed to boot on IA64 with CONFIG_DISCONTIGMEM=y
Message-Id: <20081205124947.0450a222.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4938A088.1090205@cn.fujitsu.com>
References: <49389B69.9010902@cn.fujitsu.com>
	<20081205122024.3fcc1d0e.kamezawa.hiroyu@jp.fujitsu.com>
	<20081205122458.a37ae8e0.kamezawa.hiroyu@jp.fujitsu.com>
	<4938A088.1090205@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Dec 2008 11:31:20 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> >> How about this ?
> > 
> > Ahhh..sorry.
> > 
> > this one please.
> > ==
> > 
> > From: kamezawa.hiroyu@jp.fujitsu.com
> > 
> > page_cgroup should ignore empty-nodes.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> 
> Now it booted successfully. :)
> 
> Tested-by: Li Zefan <lizf@cn.fujitsu.com>
> 
Thank you!

-Kame

