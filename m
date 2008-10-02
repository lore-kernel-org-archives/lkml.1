Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYJBTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYJBTGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYJBTGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:06:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55591 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbYJBTGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:06:23 -0400
Date: Thu, 2 Oct 2008 21:06:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, srostedt@redhat.com
Subject: Re: [PATCH -tip] ftrace: ktime.h not included in ftrace.h
Message-ID: <20081002190615.GA1685@elte.hu>
References: <1222974007-3745-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222974007-3745-1-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0179]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Noonan <steven@uplinklabs.net> wrote:

> Including <linux/ktime.h> eliminates the following error:
> 
> include/linux/ftrace.h:220: error: expected specifier-qualifier-list
> before 'ktime_t'
> 
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>

applied to tip/tracing/ftrace, thanks Steven!

	Ingo
