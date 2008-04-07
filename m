Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbYDGVdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbYDGVdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYDGVdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:33:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52145 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbYDGVdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:33:15 -0400
Date: Mon, 7 Apr 2008 23:32:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 01/10] x86_64: Cleanup non-smp usage of cpu maps v2
Message-ID: <20080407213255.GA30765@elte.hu>
References: <20080325220650.835342000@polaris-admin.engr.sgi.com> <20080325220651.011213000@polaris-admin.engr.sgi.com> <20080326064045.GF18301@elte.hu> <47FA85E4.5010005@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FA85E4.5010005@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0021]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> How about something like the below? (I haven't tried compiling it 
> yet.)

looks good to me - the closer it is to the real API, the better.

	Ingo
