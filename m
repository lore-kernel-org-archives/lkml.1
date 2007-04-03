Return-Path: <linux-kernel-owner+w=401wt.eu-S934019AbXDCCfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019AbXDCCfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 22:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934015AbXDCCfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 22:35:53 -0400
Received: from mail15.syd.optusnet.com.au ([211.29.132.196]:41485 "EHLO
	mail15.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934035AbXDCCfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 22:35:51 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: staircase deadline misc fixes
Date: Tue, 3 Apr 2007 12:35:31 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
References: <200703290237.38777.kernel@kolivas.org> <1175147455.6430.91.camel@Homer.simpson.net> <1175156283.6430.143.camel@Homer.simpson.net>
In-Reply-To: <1175156283.6430.143.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704031235.31563.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 18:18, Mike Galbraith wrote:
> Rereading to make sure I wasn't unclear anywhere...
>
> On Thu, 2007-03-29 at 07:50 +0200, Mike Galbraith wrote:
> > I don't see what a < 95% load really means.
>
> Egad.  Here I'm pondering the numbers and light load as I'm typing, and
> my fingers (seemingly independent when mind wanders off) typed < 95% as
> in not fully committed, instead of "light".

95% of cases where load is less than 4; not 95% load.

-- 
-ck
