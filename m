Return-Path: <linux-kernel-owner+w=401wt.eu-S1763174AbYDPTb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763174AbYDPTb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYDPTbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:31:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57266 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbYDPTbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:31:20 -0400
Date: Wed, 16 Apr 2008 21:31:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 and DEBUG_SECTION_MISMATCH
Message-ID: <20080416193102.GA16981@elte.hu>
References: <20080416175135.GN1677@cs181133002.pp.htv.fi> <20080416192306.GA3090@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416192306.GA3090@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2721]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> I would prefer we were down to less than 5 warnings so we could enable 
> it in kconfig but maybe after next merge window.

they get regenerated. More than 1 out of every 100 new patches. Quite 
expensive feature (in terms of maintenance overhead) for a rather 
theoretical memory saving benefit.

	Ingo
