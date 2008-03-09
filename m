Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbYCILj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbYCILj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 07:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbYCILju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 07:39:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34646 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbYCILjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 07:39:49 -0400
Date: Sun, 9 Mar 2008 12:39:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: remove pointless comments
Message-ID: <20080309113932.GA30331@elte.hu>
References: <20080308.181506.04857887.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308.181506.04857887.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2092]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* WANG Cong <xiyou.wangcong@gmail.com> wrote:

> Since arch/i386 directory is non-existed yet, those comments are 
> pointless. Remove them all.

thanks, applied.

	Ingo
