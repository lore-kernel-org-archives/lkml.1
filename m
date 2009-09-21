Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbZIUTBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbZIUTBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZIUTBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:01:47 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37353 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbZIUTBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:01:47 -0400
Date: Mon, 21 Sep 2009 21:01:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: johannes@sipsolutions.net, netdev@vger.kernel.org
Subject: "cfg80211: fix SME connect" breaks iwl3945
Message-ID: <20090921190150.GC23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

Since the latest net pull that contains our above commit
(bbac31f4c0339f6c51afbd0edfb4959df9b53fa9 in tree), my iwl3945 based x60
laptop doesn't want to connect to my access point at all. Reverting this
commit makes it work.

Let me know if you need more info.

-- 
Jens Axboe

