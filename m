Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbYHELmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbYHELmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbYHELmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:42:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46496 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbYHELmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:42:07 -0400
Date: Tue, 05 Aug 2008 20:38:56 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Race condition between putback_lru_page and mem_cgroup_move_list
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080805200556.A891.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <48982F9E.2080100@linux.vnet.ibm.com> <20080805200556.A891.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080805203811.A894.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, we can two approach

Also, we can *select* two approach.


sorry, send crap broken message ;-)


