Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYFYKBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYFYKBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 06:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYFYKB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 06:01:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43001 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbYFYKB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:01:28 -0400
Date: Wed, 25 Jun 2008 18:59:34 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>
Subject: [-mm][PATCH 0/10]  memory related bugfix set for 2.6.26-rc5-mm3 v2
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080625185717.D84C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew and mm guys!

this is mm related fixes patchset for 2.6.26-rc5-mm3 v2.

Unfortunately, this version has several bugs and 
some bugs depend on each other.
So, I collect, sort, and fold these patchs.


btw: I wrote "this patch still crashed" last midnight.
but it works well today.
umm.. I was dreaming?

Anyway, I believe this patchset improve robustness and
provide better testing baseline.

enjoy!


Andrew, this patchset is my silver-spoon.
if you like it, I'm glad too.



