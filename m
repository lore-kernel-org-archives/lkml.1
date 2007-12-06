Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbXLFCFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbXLFCFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXLFCFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:05:04 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37881 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbXLFCFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:05:02 -0500
Message-Id: <20071206020246.417605824@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:02:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [patch 00/11] Text Edit Lock for 2.6.24-rc4-git3
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:04:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a repost of the text edit lock for 2.6.24-rc4-mm3. It is useful to
coordinate modification of live kernel code patching.

It includes a modification to kprobes (its first user) and is useful for the
Immediate Values.

It could be interesting to queue it for 2.6.25.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
