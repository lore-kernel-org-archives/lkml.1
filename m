Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbXIJRFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbXIJRFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbXIJRFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:05:03 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42925 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbXIJRFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:05:01 -0400
Date: Mon, 10 Sep 2007 19:05:00 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, dhaval@linux.vnet.ibm.com
Subject: Re: [PATCH] Hookup group-scheduler with task container infrastructure
In-Reply-To: <20070910171049.GA16048@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
References: <20070910171049.GA16048@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 10 2007 22:40, Srivatsa Vaddagiri wrote:
>+#ifdef CONFIG_FAIR_GROUP_SCHED
>+SUBSYS(cpuctlr)
>+#endif

cpuctl, cpuctrl, cpu_controller?
