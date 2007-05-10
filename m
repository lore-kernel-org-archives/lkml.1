Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbXEJBjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbXEJBjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 21:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbXEJBjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 21:39:12 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:52111 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329AbXEJBjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 21:39:11 -0400
Message-Id: <20070510013555.436601330@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 May 2007 21:35:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: paulus@samba.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch 0/1] Remove #undef printk in powerpc prom.c
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 10 May 2007 01:38:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Is there a reason why there is a #undef printk in
arch/powerpc/kernel/prom.c ? It looks a little odd...

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
