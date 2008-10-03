Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbYJCIFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbYJCIFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYJCIFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:05:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37887 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbYJCIFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:05:01 -0400
Date: Fri, 3 Oct 2008 10:04:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: remove unused balloon.h
Message-ID: <20081003080445.GE25408@elte.hu>
References: <48E55C6B.5070805@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E55C6B.5070805@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0029]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The balloon driver doesn't have any externally callable functions at
> the moment, so remove the (effectively empty) header.  We can add it
> back if we need to.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> drivers/xen/balloon.c |    1 include/xen/balloon.h |   61 

applied to tip/x86/xen, thanks Jeremy!

	Ingo
