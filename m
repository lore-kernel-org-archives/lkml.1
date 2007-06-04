Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbXFDEnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbXFDEnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 00:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXFDEnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 00:43:18 -0400
Received: from srv1.netkinetics.net ([206.71.148.180]:42720 "EHLO
	srv1.netkinetics.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbXFDEnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 00:43:17 -0400
X-Greylist: delayed 3941 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2007 00:43:17 EDT
Subject: Kernel inclusion policy, meta desicion making structure?
From: Tim Post <tim.post@netkinetics.net>
Reply-To: tim.post@netkinetics.net
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Net Kinetics
Date: Mon, 04 Jun 2007 11:36:38 +0800
Message-Id: <1180928198.5786.111.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.1 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv1.netkinetics.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - netkinetics.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good day/evening to all.

I was wondering if a meta version of the decision making process that
would be employed to determine if a new contribution does or does not go
into the main stream Linux kernel.

The following abstract demonstrates my question if it does not make
sense:

"There are many file systems made for the Linux kernel. Only some of
them are present by default in released Kernels."

"There is an AoE block module in the Kernel, but not the userspace blade
module. Only one was included."

Does some document exist that shows the decision making process so that
I can easily answer the ultimate question of "Why not" for myself? It
would be fun to examine code until I could answer the question myself,
and very educational for me as a programmer. Once I figure it out, I
"own" just a little more knowledge without pestering you guys.

I would like to write my own lightweight cluster file system and make
modifications to existing cluster file systems. I think first I should
better learn in practice whats wrong with existing before I go improving
it :) This document would be the best starting point for me.

Thank you in advance for any links. My question is obscure and thus hard
to search for in the archives, I post only after doing so.

Best regards,
--Tim

