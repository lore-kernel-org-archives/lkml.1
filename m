Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbXLFCrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbXLFCrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXLFCox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:44:53 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51353 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbXLFCot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:49 -0500
Message-Id: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:43 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [patch-RFC 00/26] LTTng Kernel Trace Thread Flag
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an RFC for addition of a new thread flag, TIF_KERNEL_TRACE, to each
architecture to activate system-wide system call tracing.

This is needed by LTTng architecture dependent instrumentation.

It applies on 2.6.24-rc4-git3.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
