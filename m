Return-Path: <linux-kernel-owner+w=401wt.eu-S1751761AbZHHPRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbZHHPRi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZHHPRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:17:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54688 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbZHHPRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:17:36 -0400
Date: Sat, 8 Aug 2009 17:17:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [PATCH 0/5 v4] x86: Adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090808151731.GD28892@elte.hu>
References: <20090805154402.GA6520@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805154402.GA6520@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Note that scheduler adaptions are still under construction/test. 
> Hope to send first version as RFC by end of this week.

Ok - i'll wait for those, and they really put all this info into 
real use so bugs/inefficiencies can be noticed.

You also indicated that you'll address the feedback from Brice 
Goglin to make the semantics (and naming) more consistent across the 
kernel.

	Ingo
