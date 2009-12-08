Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZLHJ0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZLHJ0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 04:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZLHJ0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 04:26:37 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:57737
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZLHJ0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:26:36 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] clean out Perl from build system.
Date: Tue, 8 Dec 2009 03:17:07 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-16-generic; KDE/4.2.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912080317.08254.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perl was introduced as a build dependency in 2.6.25.  My cross-compile 
environment does not use perl, so ever since then I've patched it back out.

With these patches I've personally built kernels for x86, x86_64, arm, mips, 
powerpc, sparc, sh4, and m68k.
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
