Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbXISXBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbXISXBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbXISXBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:01:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:45314 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbXISXBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:01:37 -0400
Date: Wed, 19 Sep 2007 18:01:20 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: linux-kernel@vger.kernel.org
Subject: SMP interrupt controller that only supports CPU affinity?
Message-ID: <Pine.LNX.4.64.0709191758490.12897@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was wondering if there were any examples of interrupt controllers on SMP
systems that only supported CPU affinity.  I'm trying to see the best way
to ensure that desc->affinity gets set properly.

thanks

- k




