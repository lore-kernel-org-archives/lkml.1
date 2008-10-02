Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYJBPxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYJBPxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYJBPxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:53:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40090 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbYJBPxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:53:12 -0400
Date: Thu, 2 Oct 2008 17:52:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Oruba <peter.oruba@amd.com>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: sleeping function called from invalid context at kernel/mutex.c
Message-ID: <20081002155258.GA32190@elte.hu>
References: <48E25B25.10408@yahoo.com> <20081001071004.GA9366@elte.hu> <b647ffbd0810020029v1fd59d85u8d8048aebe3e4d55@mail.gmail.com> <48E4882E.5000100@amd.com> <20081002085529.GB3550@elte.hu> <b647ffbd0810020656l48eba7bdt8cd8e4cd47a8a95b@mail.gmail.com> <b647ffbd0810020659j2e5d38c2v51847000de682492@mail.gmail.com> <b647ffbd0810020701l60ee69fx9360baa5a4b855e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0810020701l60ee69fx9360baa5a4b855e8@mail.gmail.com>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> >  Right, I've been looking at the wrong tree. Please find the fix 
> >  enclosed. Compiles ok, shouldn't break anything else.

applied to tip/x86/microcode, thanks Dmitry!

	Ingo
