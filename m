Return-Path: <linux-kernel-owner+w=401wt.eu-S1763901AbXGUTDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763901AbXGUTDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763248AbXGUTB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:01:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42895 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763196AbXGUTB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:01:57 -0400
Message-Id: <20070721210005.000228000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jul 2007 23:00:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/3] readahead drop behind and size adjustment
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The various readahead bits I have lying about.

Wu, would you agree with asking Andrew to stick these behind your latest
readahead series?


