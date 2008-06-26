Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYFZIGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYFZIGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYFZIG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:06:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43262 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbYFZIG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:06:26 -0400
Date: Thu, 26 Jun 2008 10:06:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       kexec@lists.infradead.org
Subject: Re: [PATCH] Remove CONFIG_EXPERIMENTAL from kdump
Message-ID: <20080626080603.GD16168@elte.hu>
References: <20080625221635.GD32344@redhat.com> <1214465001-12338-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214465001-12338-1-git-send-email-bwalle@suse.de>
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


* Bernhard Walle <bwalle@suse.de> wrote:

> I would suggest to remove the "experimental" status from Kdump. Kdump 
> is now in the kernel since a long time and used by Enterprise 
> distributions. I don't think that "experimental" is true any more.

agreed. I have applied your patch to tip/x86/crashdump (separate topic 
due to its fs/Kconfig impact).

Thanks Bernhard,

	Ingo
