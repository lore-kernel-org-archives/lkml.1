Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbYGAUdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbYGAUdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbYGAUdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:33:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49895 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbYGAUde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:33:34 -0400
Date: Tue, 1 Jul 2008 22:33:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
Message-ID: <20080701203324.GH4896@elte.hu>
References: <1214565175-21512-1-git-send-email-bwalle@suse.de> <1214565175-21512-2-git-send-email-bwalle@suse.de> <20080627205625.GA16609@kroah.com> <20080701223047.4cb8fa78@kopernikus.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701223047.4cb8fa78@kopernikus.site>
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

> * Greg KH <gregkh@suse.de> [2008-06-27 13:56]:
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > x86 developers, feel free to add this to your tree, it looks fine to me.
> 
> Ingo, any pending issues from your side that prevents merging in 
> 'tip'?

nope, no pending issues now that Greg has acked it - will create a topic 
for it tomorrow.

	Ingo
