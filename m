Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbYF1NO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbYF1NO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYF1NOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:14:35 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:44591 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbYF1NOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:14:34 -0400
Date: Sat, 28 Jun 2008 17:17:15 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] coredump: introduce struct core_state.
Message-ID: <20080628131715.GA4406@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-send.

The second patch was changed to not depend on ignored
"ptrace: kill may_ptrace_stop()" patch.

I think this series makes sense by itself, but it is also preparation
for the further changes.

Oleg.

