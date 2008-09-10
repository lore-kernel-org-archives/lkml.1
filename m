Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYIJGXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYIJGXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYIJGX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:23:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39500 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbYIJGX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:23:28 -0400
Date: Wed, 10 Sep 2008 08:23:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: make intel.c has 64bit support code
Message-ID: <20080910062311.GA14700@elte.hu>
References: <1221003639-15912-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221003639-15912-1-git-send-email-yhlu.kernel@gmail.com>
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


applied these patches to tip/x86/unify-cpu-detect:

 ec70cae: x86: centaur_64.c remove duplicated setting of CONSTANT_TSC
 4052704: x86: intel.c put workaround for old cpus together
 879d792: x86: let intel 64-bit use intel.c
 58602c1: x86: make intel_64.c the same as intel.c
 185f3b9: x86: make intel.c have 64-bit support code

thanks Yinghai!

	Ingo
