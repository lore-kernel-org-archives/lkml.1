Return-Path: <linux-kernel-owner+w=401wt.eu-S935498AbYCFVAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935498AbYCFVAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbYCFVAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:00:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36429 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100AbYCFVAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:00:11 -0500
Date: Thu, 6 Mar 2008 21:59:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: g.liakhovetski@gmx.de, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, bunk@kernel.org, gregkh@suse.de
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Message-ID: <20080306205951.GA23989@elte.hu>
References: <200803030316.07165.rjw@sisk.pl> <20080306072704.GA28518@elte.hu> <Pine.LNX.4.64.0803062054110.8669@axis700.grange> <20080306121127.42ac0682.akpm@linux-foundation.org> <20080306125153.d95db2b9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306125153.d95db2b9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> I'd love to poke around in kgdb (what does kthread_stop_info.k point 
> at?) but it seems that -mm's copy of kgdb got taken away when I wasn't 
> looking. Can I have it back please?

it's in the full x86.git or you can pick up the kgdb-light tree:

  http://people.redhat.com/mingo/kgdb-light.git/README

	Ingo
