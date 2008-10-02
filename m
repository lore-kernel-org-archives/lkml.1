Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYJBIgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYJBIgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYJBIgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:36:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60728 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbYJBIgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:36:16 -0400
Date: Thu, 2 Oct 2008 10:36:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] Markers fixes
Message-ID: <20081002083609.GB26084@elte.hu>
References: <20081001160324.889716972@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001160324.889716972@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0988]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi Ingo,
> 
> Here are the marker fixes which reenable batch markers
> registration/unregistration. They apply to -tip.

hm, only the first patch applies to tip/master - the rest is already 
applied. So i applied the first patch to tip/tracing/markers:

  # a2b4a6c: markers: re-enable fast batch registration

Could you please check latest tip/master:

  http://people.redhat.com/mingo/tip.git/README

to make sure that i sorted them out correctly. Thanks,

	Ingo
