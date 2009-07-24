Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbZGXI5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbZGXI5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 04:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZGXI5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 04:57:21 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:22123 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZGXI5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 04:57:20 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [patch] perf tools: allow top users to switch between weighted
 and individual counter display
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1248422990.28486.3.camel@marge.simson.net>
References: <1248422990.28486.3.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 10:58:57 +0200
Message-Id: <1248425937.6987.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 10:09 +0200, Mike Galbraith wrote:
> (depends on last resurrect annotation patch)
> 
> perf_counter tools: allow top users to switch between weighted and individual counter display.
> 
> Add [w]eighted hotkey.  Pressing [w] toggles between displaying weighted total of all counters,
> and the counter selected via [E]vent select key.

/me stuck it next to that other one, let see what happens ;-)

Thanks Mike.

