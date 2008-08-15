Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYHOPU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYHOPU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYHOPUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:20:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40698 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbYHOPUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:20:17 -0400
Date: Fri, 15 Aug 2008 17:19:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/2] x86: microcode patch loader cleanup and fix
Message-ID: <20080815151925.GH10029@elte.hu>
References: <20080801104644.788786464@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801104644.788786464@amd.com>
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


* Peter Oruba <peter.oruba@amd.com> wrote:

> This patch set cleans up vendor independent microcode loading module 
> and corrects one misbehaviour in AMD specific module.

applied to tip/x86/microcode - thanks Peter.

	Ingo
