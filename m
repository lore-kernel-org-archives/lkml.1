Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbXHTUTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbXHTUTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbXHTUS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:18:29 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53534 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759121AbXHTUS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:18:28 -0400
Message-Id: <20070820201519.512791382@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 16:15:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 00/23] cmpxchg_local and cmpxchg64_local implementation
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 20 Aug 2007 20:18:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Changelog from the last post for this patchset:

- explained more thoroughly design choices in
  i386-cmpxchg64-80386-80486-fallback patch header.
- m32r compilation fix.
- ia64 coding style fix.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
