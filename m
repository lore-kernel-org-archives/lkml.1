Return-Path: <linux-kernel-owner+w=401wt.eu-S1764676AbZAOLVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764676AbZAOLVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbZAOLVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:21:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53066 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758009AbZAOLVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:21:40 -0500
Date: Thu, 15 Jan 2009 12:21:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] perf_counter: Add support for pinned and exclusive
	counter groups
Message-ID: <20090115112125.GD22850@elte.hu>
References: <18797.44875.470975.535175@cargo.ozlabs.ibm.com> <18798.40466.741696.758199@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18798.40466.741696.758199@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> This patch is in the rfc branch of my perfcounters.git repository at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git rfc
> 
> Ingo - you can pull it into your perfcounters branch if you like.

Pulled into tip/perfcounters/core, thanks Paul!

	Ingo
