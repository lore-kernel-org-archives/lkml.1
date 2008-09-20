Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbYITLeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbYITLeU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 07:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYITLeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 07:34:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42125 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbYITLeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 07:34:08 -0400
Date: Sat, 20 Sep 2008 13:33:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] trace: remove pointless ifdefs
Message-ID: <20080920113353.GC30234@elte.hu>
References: <20080920061659.GF25713@elte.hu> <1221897638-16272-1-git-send-email-steven@uplinklabs.net> <1221897638-16272-2-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221897638-16272-2-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0156]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Noonan <steven@uplinklabs.net> wrote:

> The functions are already 'extern' anyway, so there's no problem with 
> linkage. Removing these ifdefs also helps find any potential compiler 
> errors.
> 
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>

applied to tip/tracing/ftrace, thanks Steven,

	Ingo
