Return-Path: <linux-kernel-owner+w=401wt.eu-S1760516AbYHOTzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516AbYHOTzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbYHOTzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:55:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43576 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbYHOTzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:55:10 -0400
Date: Fri, 15 Aug 2008 21:54:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, srostedt@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace: Fix some mistakes in error messages
Message-ID: <20080815195459.GA25185@elte.hu>
References: <48A0B82B.7090200@gmail.com> <20080815125937.GB30597@elte.hu> <48A5D426.20703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48A5D426.20703@gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> Ingo Molnar a écrit :
> > * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> > 
> >> This patch fixes some mistakes on the tracer in warning messages when 
> >> debugfs fails to create tracing files. Kernel version: 2.6.27-rc1
> > 
> > hm, the patch is nice, but it is whitespace damaged. Please resend along 
> > the lines of Documentation/email-clients.txt, or as an attachment.
> > 
> > 	Ingo
> 
> 
> Sorry. Now it should be correct.
> 
> Pach V2
> -------
> 
> This patch fixes some mistakes on the tracer in warning messages when 
> debugfs fails to create tracing files.

applied to tip/tracing/ftrace - thanks Frédéric!

	Ingo
