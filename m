Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbXLFC2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbXLFC2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbXLFC15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:27:57 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:50011 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbXLFC15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:27:57 -0500
Message-Id: <20071206022555.150400591@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:25:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [patch-RFC 0/7] LTTng instrumentation (arch independent)
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:27:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the second RFC post for the LTTng architecture independent
instrumentation. I have mostly received interesting ideas from the mm group,
which I have added here.

It applies on top of 2.6.24-rc4-git3, on top of the Linux Kernel Markers with
Immediate Values patchset.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
