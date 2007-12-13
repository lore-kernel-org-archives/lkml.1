Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbXLMKKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbXLMKKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXLMKKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:10:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35539 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbXLMKKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:10:04 -0500
Date: Thu, 13 Dec 2007 11:09:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Remove all definitions with fastcall
Message-ID: <20071213100949.GK8977@elte.hu>
References: <1197491364.21291.14.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197491364.21291.14.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> fastcall is always defined to be empty, remove it from arch/x86

thanks, i've applied this and your other fastcall patches to x86.git. 
(except for the non-x86 bits - those will go upstream via the other 
trees.)

	Ingo
