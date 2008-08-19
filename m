Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYHSARu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYHSARu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYHSARn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:17:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39580 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbYHSARm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:17:42 -0400
Date: Tue, 19 Aug 2008 02:17:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
       Leo Duran <leo.duran@amd.com>
Subject: Re: [PATCH] x86 iommu: remove unneeded parenthesis
Message-ID: <20080819001728.GD9914@elte.hu>
References: <alpine.LNX.1.10.0808190211060.18058@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0808190211060.18058@jikos.suse.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> The parenthesis in __iommu_queue_command() are not needed when assigning  
> into 'target' variable.
>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

applied to tip/x86/urgent - thanks Jiri.

[ Btw., the patch was whitespace damaged (leading double spaces, etc.), 
  i fixed it up by hand. Please check Documentation/email-clients.txt. ]

	Ingo
