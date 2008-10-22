Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYJVNht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYJVNht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYJVNhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:37:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56631 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbYJVNhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:37:39 -0400
Date: Wed, 22 Oct 2008 15:37:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] OProfile for v2.6.28
Message-ID: <20081022133725.GA10215@elte.hu>
References: <20081022132858.GA11994@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022132858.GA11994@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0622]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Hi Linus,
> 
> here are all OProfile patches for v2.6.28. The patches are also in the 
> tip tree. However, you can also pull from here to get the changes:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-linus

they tested out fine here on various machines. Thanks Robert,

	Ingo
