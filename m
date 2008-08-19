Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbYHSJ6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbYHSJ6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYHSJ6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:58:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41336 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622AbYHSJ6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:58:21 -0400
Date: Tue, 19 Aug 2008 11:58:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix build error in kernel/rcuclassic.c with latest
	tip/master
Message-ID: <20080819095802.GA6722@elte.hu>
References: <1219139452-7435-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219139452-7435-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch fixes the following build error for me:

just pushed out a similar fix from Hiroshi Shimamo - please check 
whether latest tip/master build fine for you.

	Ingo
