Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYFSJHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYFSJHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYFSJHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:07:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43799 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYFSJHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:07:22 -0400
Date: Thu, 19 Jun 2008 18:07:05 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [-mm][PATCH 0/5] memory related bugfix set for 2.6.26-rc5-mm3 
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080619172241.E7FC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew and -mm guys!

Unfortunately, linux-2.6.26-rc5-mm3 has several bugs and 
some bugs depend on each other.

thus, I collect, sort, and fold these patchs..
this patchset surve on my stress workload >5H.

enjoy!



