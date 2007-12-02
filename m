Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbXLBPOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbXLBPOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 10:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbXLBPOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 10:14:43 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:37473 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbXLBPOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 10:14:42 -0500
Date: Sun, 2 Dec 2007 18:14:54 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] fix the long standing exec vs kill race
Message-ID: <20071202151454.GA13180@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depends on
	[PATCH] __group_complete_signal: fix coredump with group stop race
	http://marc.info/?l=linux-kernel&m=119653436116036

Needs review and testing.

Please comment, I think at least the idea is promising.

Oleg.

