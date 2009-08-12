Return-Path: <linux-kernel-owner+w=401wt.eu-S932393AbZHLJxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbZHLJxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932281AbZHLJxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:53:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:37745 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbZHLJx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:53:29 -0400
Subject: Re: [GIT PULL] perf tools: Factorize common code
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Brice Goglin <Brice.Goglin@inria.fr>
In-Reply-To: <1250069162-13099-1-git-send-email-fweisbec@gmail.com>
References: <1250069162-13099-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Aug 2009 11:52:55 +0200
Message-Id: <1250070775.10001.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 11:25 +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> This set factorizes the common definition of structs, functions,
> variables inside perf tools to make it easier for perf trace to
> be created.
> 
> I guess this patchset only factorizes 10 % of what could be done,
> the largest part is the intersection between perf report and perf
> annotate. It's a lot of work.
> 
> I guess I will do the rest in separate patchsets while writing
> perf trace.

Awesome, much needed cleanups.

Thanks
