Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbYGUKyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbYGUKyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbYGUKxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:53:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45719 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957AbYGUKxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:53:51 -0400
Date: Mon, 21 Jul 2008 12:53:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: iwlwifi: fix build bug in "iwlwifi: fix LED stall"
Message-ID: <20080721105335.GA8776@elte.hu>
References: <20080720.104411.81744468.davem@davemloft.net> <20080721083654.GA19849@elte.hu> <C07C4589BE74A34981C3C3525EE1F801042DD9DC@hasmsx412.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C07C4589BE74A34981C3C3525EE1F801042DD9DC@hasmsx412.ger.corp.intel.com>
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


* Winkler, Tomas <tomas.winkler@intel.com> wrote:

> 
> 
> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu]
> >Sent: Monday, July 21, 2008 11:37 AM
> >To: David Miller
> >Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Winkler,
> Tomas;
> >John W. Linville
> >Subject: iwlwifi: fix build bug in "iwlwifi: fix LED stall"
> >
> >
> >hi David,
> >
> >>       iwlwifi: fix LED stall
> >
> >please find a small build fix below.
> >
>
> There are already patches that fix this. John has to pick them up from 
> the mail. Thanks Tomas

could you post the fix in this thread too please?

	Ingo
