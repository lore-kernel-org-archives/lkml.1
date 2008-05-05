Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbYEEHDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbYEEHDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYEEHDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:03:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47122 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbYEEHDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:03:37 -0400
Date: Mon, 5 May 2008 09:03:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, hpa@zytor.com, tglx@linutronix.de,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC] x86: x86-64defconfig remake
Message-ID: <20080505070323.GF3350@elte.hu>
References: <20080504155719.GA6842@cvg> <20080504181359.a39d766b.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504181359.a39d766b.pj@sgi.com>
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


* Paul Jackson <pj@sgi.com> wrote:

> The one I notice:
> 
> -# CONFIG_CPUSETS is not set

that is enabled in the update i did (which was pushed out to x86.git 
yesterday). You can check it at:

  http://people.redhat.com/mingo/x86.git/README

	Ingo
