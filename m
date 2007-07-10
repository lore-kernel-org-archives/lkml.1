Return-Path: <linux-kernel-owner+w=401wt.eu-S1763515AbXGJRcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763515AbXGJRcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758476AbXGJRcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:32:35 -0400
Received: from [212.12.190.11] ([212.12.190.11]:34417 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758326AbXGJRce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:32:34 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: [RFT][PATCH] mm: drop behind
Date: Tue, 10 Jul 2007 20:32:23 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707102032.23372.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>
> Use the read-ahead code to provide hints to page reclaim.
>
> This patch has the potential to solve the streaming-IO trashes my
> desktop problem.

Great!

Can you post a patch against 2.6.22?


Thanks!

--
Al

