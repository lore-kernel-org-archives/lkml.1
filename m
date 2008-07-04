Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbYGDCnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbYGDCnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 22:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbYGDCnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 22:43:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47146 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbYGDCm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 22:42:59 -0400
Date: Fri, 4 Jul 2008 11:48:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "riel@redhat.com" <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Question: split-lur // Re: 2.6.26-rc8-mm1
Message-Id: <20080704114804.081a850a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080703020236.adaa51fa.akpm@linux-foundation.org>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In split-lru, zone->prev_priority seems not to be used.
(just remembers....)
Is this obsolete parameter ? 

I'm sorry if I miss something.

Thanks,
-Kame

