Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYIGPlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYIGPlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 11:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYIGPlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 11:41:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37816 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbYIGPlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 11:41:13 -0400
Date: Sun, 7 Sep 2008 17:40:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Hugh Dickens <hugh@veritas.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Rafa? Mi?ecki <zajec5@gmail.com>
Subject: Re: [PATCH 4/3] x86: default corruption check to off, but put
	parameter default in Kconfig
Message-ID: <20080907154055.GA31025@elte.hu>
References: <patchbomb.1220777491@localhost> <72081a970effa1a32861.1220777494@localhost> <20080907091112.GA5574@elte.hu> <48C3A0DC.8000206@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C3A0DC.8000206@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0166]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Default the low memory corruption check to off, but make the default 
> setting of the memory_corruption_check kernel parameter a config 
> parameter.

i applied the four patches to a new -tip topic: 
tip/x86/memory-corruption-check, thanks Jeremy.

	Ingo
