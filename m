Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbZCOU0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbZCOU0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758147AbZCOUZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:25:44 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58944 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757907AbZCOUZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:25:43 -0400
Message-Id: <20090315200144.017321577@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 16:01:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC patch 00/20] LTTng Kernel Trace Thread Flag v2
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 20:24:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic noticed that the assembly file modifications I did were not present in
the TIF_* modifications. So I took them from my lttng architecture specific
instrumentation files and integrated them into each architecture's TIF addition.

Sorry for the quick repost.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
