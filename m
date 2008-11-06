Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYKFFbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYKFFbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 00:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbYKFFb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 00:31:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52193 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYKFFb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 00:31:28 -0500
Message-Id: <20081106053029.595679750@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 06 Nov 2008 00:30:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/1] ring-buffer: raw spinlock fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (1):
      ring-buffer: convert to raw spinlocks


