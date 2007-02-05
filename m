Return-Path: <linux-kernel-owner+w=401wt.eu-S1752266AbXBEJzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbXBEJzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 04:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXBEJzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 04:55:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48412 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbXBEJzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 04:55:36 -0500
Date: Mon, 5 Feb 2007 10:02:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: v2.6.20-rt1, yum/rpm
Message-ID: <20070205090258.GA442@elte.hu>
References: <20070205065636.GA1652@elte.hu> <87wt2xdksl.fsf@depni.sinp.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wt2xdksl.fsf@depni.sinp.msu.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Serge Belyshev <belyshev@depni.sinp.msu.ru> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > i have released the v2.6.20-rt1 kernel, which can be downloaded from 
> > the usual place:
> 
> I did not find tarball with split patches there. Could you please make 
> it available somewhere via http or ftp?

it basically consists of the -hrt queue, the GTOD queue (both are 
available in -mm) plus the rest of -rt in a mostly monolithic fashion. I 
dont really want to post it in a queue form because most of the time 
it's not bisectable, etc. It's really an internal thing - i do my 
development on the full tree, so that's the primary source form anyway.

	Ingo
