Return-Path: <linux-kernel-owner+w=401wt.eu-S938653AbXG3JXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938653AbXG3JXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933839AbXG3JXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:23:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33058 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157AbXG3JXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:23:47 -0400
Date: Mon, 30 Jul 2007 11:23:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -rt 2/9] Dont allow non-threaded softirqs and threaded
	hardirqs
Message-ID: <20070730092331.GB25640@elte.hu>
References: <20070730024534.369897977@mvista.com> <20070730024718.890110769@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730024718.890110769@mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> I think this was sent before, and it did cause problems before. Would 
> there be *any* reason to have non-threaded softirqs but threaded 
> hardirqs. I can see lots of issues with that.

please elaborate in precise terms: what issues can you see?

	Ingo
