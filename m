Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbZEMDKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbZEMDKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZEMDGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49485 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbZEMDGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:06 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 0/4] various zone_reclaim cleanup
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090513120155.5879.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 May 2009 12:06:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

here is zone_reclaim related various cleanups.

[1/4] vmscan: change the number of the unmapped files in zone reclaim
[2/4] vmscan: drop PF_SWAPWRITE from zone_reclaim
[3/4] vmscan: zone_reclaim use may_swap
[4/4] zone_reclaim_mode is always 0 by default


Please comment.



