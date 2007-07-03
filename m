Return-Path: <linux-kernel-owner+w=401wt.eu-S1759087AbXGCQko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087AbXGCQko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbXGCQkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:40:35 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:44445 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbXGCQke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:40:34 -0400
Message-Id: <20070703163818.785635235@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:38:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] Text Edit Lock (i386)
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:40:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the updated text edit lock, which protects the text segment
modifications (paravirt, kprobes, immediate values).

Is applies on 2.6.22-rc6-mm1. It depends on the cpa fixes I sent previously.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
