Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbYIERwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbYIERwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYIERvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:51:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59915 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbYIERvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:51:51 -0400
Date: Fri, 5 Sep 2008 19:51:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/oprofile: fix duplicate function declarations
Message-ID: <20080905175140.GD27395@elte.hu>
References: <1220346244-15674-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220346244-15674-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0519]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> This patch fixes duplicate function declarations intrduced with commit
> 19263c35e6de34095ec208015bf472df1a725c63.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>

oops, thanks - i fixed up tip/auto-oprofile-next.

	Ingo
