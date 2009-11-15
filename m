Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbZKOO1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbZKOO1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 09:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZKOO1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 09:27:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37125 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbZKOO1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 09:27:10 -0500
Date: Sun, 15 Nov 2009 15:27:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: perf stat output
Message-ID: <20091115142708.GA27553@elte.hu>
References: <193b0f820911121403w35c57158kf3721309e1f2ebd7@mail.gmail.com>
 <20091115091343.GA17358@elte.hu>
 <20091115140507.GB21561@skywalker.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091115140507.GB21561@skywalker.lan>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lucas De Marchi <lucas.de.marchi@gmail.com> wrote:

> Ingo, following the tested patch you asked. It's a bit different of 
> what you sent because branch-misses is counted in another struct.

Looks perfect - applied it to tip:perf/core for v2.6.33 merging, thanks 
Lucas!

	Ingo
