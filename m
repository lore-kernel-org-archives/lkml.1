Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbZGXKhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbZGXKhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZGXKhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:37:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:59930 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752542AbZGXKhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:37:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18br40chWcbg/SbcwsXYVsdjCLflwanM472j5nfqA
	UngNqvzIQzpeEb
Subject: Re: [patch] perf tools: allow top users to switch between weighted
 and individual counter display
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1248425937.6987.0.camel@twins>
References: <1248422990.28486.3.camel@marge.simson.net>
	 <1248425937.6987.0.camel@twins>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 12:37:01 +0200
Message-Id: <1248431821.9722.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 10:58 +0200, Peter Zijlstra wrote:
> On Fri, 2009-07-24 at 10:09 +0200, Mike Galbraith wrote:
> > (depends on last resurrect annotation patch)
> > 
> > perf_counter tools: allow top users to switch between weighted and individual counter display.
> > 
> > Add [w]eighted hotkey.  Pressing [w] toggles between displaying weighted total of all counters,
> > and the counter selected via [E]vent select key.
> 
> /me stuck it next to that other one, let see what happens ;-)

(plugs in Bitwolf-9000 charger)

