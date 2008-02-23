Return-Path: <linux-kernel-owner+w=401wt.eu-S1762258AbYBWKJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258AbYBWKJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYBWKJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:09:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60869 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbYBWKJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:09:09 -0500
Date: Sat, 23 Feb 2008 11:08:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 08/16] x86: use get_personality()
Message-ID: <20080223100849.GC23833@elte.hu>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com> <12037544671847-git-send-email-xiyou.wangcong@gmail.com> <1203754478165-git-send-email-xiyou.wangcong@gmail.com> <1203754488669-git-send-email-xiyou.wangcong@gmail.com> <12037544991876-git-send-email-xiyou.wangcong@gmail.com> <1203754509934-git-send-email-xiyou.wangcong@gmail.com> <1203754519825-git-send-email-xiyou.wangcong@gmail.com> <12037545311452-git-send-email-xiyou.wangcong@gmail.com> <12037545424136-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12037545424136-git-send-email-xiyou.wangcong@gmail.com>
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


* WANG Cong <xiyou.wangcong@gmail.com> wrote:

> Use get_personality() macro instead of explicit reference for x86 
> code.

thanks, applied.

	Ingo
