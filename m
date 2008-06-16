Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbYFPQ3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbYFPQ3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 12:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbYFPQ3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 12:29:47 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33073 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbYFPQ3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 12:29:47 -0400
Date: Mon, 16 Jun 2008 20:31:39 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] coredump: introduce struct core_state.
Message-ID: <20080616163139.GA21040@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second patch depends on

	[PATCH 3/3] ptrace: kill may_ptrace_stop()
	http://marc.info/?l=linux-kernel&m=121362601702897

I think this series makes sense by itself, but it is also preparation
for the further changes.

Oleg.

