Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYAOB0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYAOB0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 20:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYAOB0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 20:26:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47102 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbYAOB0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 20:26:40 -0500
Date: Tue, 15 Jan 2008 10:24:22 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Cc: kosaki.motohiro@jp.fujitsu.com, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080115101803.1183.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080114170804.b5961aea.randy.dunlap@oracle.com> <20080115101803.1183.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080115102327.1186.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > 1/ I don't see the file below listed in the diffstat above...
> 
> Agghh...
> sorry, it is mistake.
> I repost soon. 
> 
> thanks.

the below diffstat is correct.
thanks!

------------------------------
 Documentation/devices.txt  |    1
 drivers/char/mem.c         |    6 ++
 include/linux/mem_notify.h |   42 +++++++++++++++++
 include/linux/mmzone.h     |    1
 mm/Makefile                |    2
 mm/mem_notify.c            |  109 +++++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c            |    1
 7 files changed, 161 insertions(+), 1 deletion(-)


