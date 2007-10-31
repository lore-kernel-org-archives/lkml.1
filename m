Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbXJaAdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbXJaAdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbXJaAdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:33:32 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:50316 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbXJaAdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:33:31 -0400
Message-Id: <20071031003140.904670073@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 30 Oct 2007 20:31:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Subject: [patch 0/4] Creation of arch/Kconfig for ARCH_SUPPORTS_* options
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 00:33:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the implementation of the arch/Kconfig, meant to keep archtecture
specific menu entries repeated across many (but not all) architectures.
ARCH_SUPPORTS_* should be defined in architectures that supports the option.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
