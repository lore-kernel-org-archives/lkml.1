Return-Path: <linux-kernel-owner+w=401wt.eu-S936103AbYD1RmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936103AbYD1RmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933501AbYD1Rlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:41:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60147 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933142AbYD1Rlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:41:49 -0400
Date: Mon, 28 Apr 2008 19:41:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Priit Laes <plaes@plaes.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [REGRESSION] x86: support for new UV apic
Message-ID: <20080428174133.GA27584@elte.hu>
References: <1209098600.3707.13.camel@localhost> <20080425064405.GA23043@elte.hu> <87abjixo7d.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87abjixo7d.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0621]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Alternative patch appended.

> Don't warn in read_apic_id() when preemptible but only one CPU online.

applied, thanks Andi.

	Ingo
