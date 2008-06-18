Return-Path: <linux-kernel-owner+w=401wt.eu-S1751702AbYFRHrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbYFRHrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 03:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbYFRHrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 03:47:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39306 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbYFRHrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 03:47:08 -0400
Date: Wed, 18 Jun 2008 09:46:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] x86/pci: Renaming k8-bus_64.c to amd_bus.c
Message-ID: <20080618074649.GA4135@elte.hu>
References: <20080603072550.GR23679@erda.amd.com> <1213294763-19566-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213294763-19566-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> The name fits better since this is code not only for K8.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>

applied to tip/x86/cpu, thanks Robert.

	Ingo
