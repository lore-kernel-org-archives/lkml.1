Return-Path: <linux-kernel-owner+w=401wt.eu-S1765665AbYBMBDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765665AbYBMBDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbYBMBCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:02:15 -0500
Received: from mail.vyatta.com ([216.93.170.194]:39824 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbYBMBCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:02:10 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.499
Message-Id: <20080213005042.150212716@vyatta.com>
User-Agent: quilt/0.46-1
Date: Tue, 12 Feb 2008 16:50:42 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] fib_trie related patches for 2.6.25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More trie cleanups with some RCU related changes as well.
Patches are against net-2.6 tree (sent already to netdev).
-- 
Stephen Hemminger <shemminger@vyatta.com>

