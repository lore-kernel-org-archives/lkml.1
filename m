Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbZADNEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbZADNEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZADNEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:04:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56486 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZADNEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:04:35 -0500
Date: Sun, 4 Jan 2009 14:04:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Sripathi Kodi <sripathik@in.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] getrusage: RUSAGE_THREAD should return ru_utime and
	ru_stime
Message-ID: <20090104130418.GA27048@elte.hu>
References: <20090104053654.069C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090103210617.18CBAFC299@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103210617.18CBAFC299@magilla.sf.frob.com>
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


* Roland McGrath <roland@redhat.com> wrote:

> I think you're right.  Good catch.
> 
> Acked-by: Roland McGrath <roland@redhat.com>

applied to tip/sched/urgent, thanks guys!

	Ingo
