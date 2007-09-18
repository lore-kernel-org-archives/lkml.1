Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbXIRDAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbXIRDAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 23:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbXIRDAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 23:00:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57557 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbXIRDAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 23:00:20 -0400
Date: Tue, 18 Sep 2007 12:02:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mel@csn.ul.ie" <mel@csn.ul.ie>
Subject: Re: [PATCH] CONFIG_ZONE_MOVABLE [2/2] config zone movable
Message-Id: <20070918120241.6d2d5110.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070917194748.a6edb8a5.akpm@linux-foundation.org>
References: <20070831191202.50fe90b3.kamezawa.hiroyu@jp.fujitsu.com>
	<20070831191415.a111636b.kamezawa.hiroyu@jp.fujitsu.com>
	<20070917194748.a6edb8a5.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 19:47:48 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 31 Aug 2007 19:14:15 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > Makes ZONE_MOVABLE as configurable
> > 
> > Based on "zone_ifdef_cleanup_by_renumbering.patch"
> > 
> 
> This patch causes my old dual-pIII machine to instantly reboot: 0.000001 seconds
> uptime.
> 
> http://userweb.kernel.org/~akpm/config-vmm.txt

Ok, will find problem.

Thanks,
-Kame

