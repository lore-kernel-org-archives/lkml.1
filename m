Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbYGCNRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbYGCNRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYGCNRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:17:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55151 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYGCNRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:17:06 -0400
Date: Thu, 3 Jul 2008 15:16:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, vgoyal@redhat.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix documentation bug about relocatability
Message-ID: <20080703131634.GB12102@elte.hu>
References: <1214510118-21405-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214510118-21405-1-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0301]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bernhard Walle <bwalle@suse.de> wrote:

> This patch fixes a small bug in documentation: x86_64 also has now the 
> ability to build a relocatable kernel.

applied to tip/x86/crashdump - thanks Bernhard.

	Ingo
