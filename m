Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYINM5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYINM5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 08:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYINM5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 08:57:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40031 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbYINM5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 08:57:40 -0400
Date: Sun, 14 Sep 2008 14:57:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: simpler SYSVIPC_COMPAT definition
Message-ID: <20080914125728.GB22281@elte.hu>
References: <20080914094441.GA3538@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914094441.GA3538@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0752]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> X86_64 part is entirely redundant.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

applied to tip/x86/cleanups, thanks Alexey.

	Ingo
