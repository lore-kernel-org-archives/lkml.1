Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbZLZWK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbZLZWK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 17:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZLZWKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 17:10:55 -0500
Received: from toro.web-alm.net ([62.245.132.31]:35207 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbZLZWKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 17:10:54 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Dec 2009 17:10:54 EST
Message-Id: <20091226214114.843059850@osadl.org>
User-Agent: quilt/0.47-1
Date: Sat, 26 Dec 2009 22:41:14 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH 0/2] tracing: Expand ftrace documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The meaning of the tracing_max_latency variable
was not entirely clear from the documentation.
The variable trace_clock was not explained in
the documentation.

