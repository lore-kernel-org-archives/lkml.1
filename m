Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbYD2MPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbYD2MPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYD2MO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:14:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34681 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbYD2MOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:14:55 -0400
Date: Tue, 29 Apr 2008 14:14:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mkrufky@linuxtv.org
Cc: mchehab@infradead.org, bunk@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Message-ID: <20080429121438.GD31271@elte.hu>
References: <20080428182501.5bb87058@gaivota> <481641CD.5030202@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481641CD.5030202@linuxtv.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* mkrufky@linuxtv.org <mkrufky@linuxtv.org> wrote:

> The fix for this issue will come "for free" after the tuner location 
> reorganization to the media/common/ folder.

btw., will that go into v2.6.26? If not automatically then please push 
it into ahead separately if possible.

	Ingo
