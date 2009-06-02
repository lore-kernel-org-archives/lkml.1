Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbZFBDGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbZFBDGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 23:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZFBDGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 23:06:01 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42784 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbZFBDGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 23:06:00 -0400
Date: Tue, 2 Jun 2009 12:04:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] memcg fix swap accounting (2/Jun)
Message-Id: <20090602120425.0bcff554.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated sereis of memcg fix swap accounting
 http://marc.info/?l=linux-mm&m=124348659700540&w=2

Now in mmotm as
 mm-add-swap-cache-interface-for-swap-reference.patch
 mm-modify-swap_map-and-add-swap_has_cache-flag.patch
 mm-reuse-unused-swap-entry-if-necessary.patch
 memcg-fix-swap-accounting.patch

No logic changes but fixed some condig style troubles pointed out.

Thanks,
-Kame

