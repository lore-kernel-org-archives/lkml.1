Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbZDNQ6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbZDNQ6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbZDNQ5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:57:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59473 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757965AbZDNQ5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:57:40 -0400
Date: Tue, 14 Apr 2009 18:57:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 00/14] convert voyager over to the x86 quirks model
Message-ID: <20090414165722.GD2089@elte.hu>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

>  39 files changed, 554 insertions(+), 726 deletions(-)

That diffstat is not against current mainline, is it? Would 
you mind to send a proper diffstat with the revert included 
as well? That will give us a complete picture.

	Ingo
