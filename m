Return-Path: <linux-kernel-owner+w=401wt.eu-S935752AbZFOVhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935752AbZFOVhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934990AbZFOVhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:37:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39555 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934762AbZFOVhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:37:08 -0400
Date: Mon, 15 Jun 2009 23:32:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/2] posix-cpu-timers: random fixes rework -v3
Message-ID: <20090615213216.GA22766@redhat.com>
References: <20090615103640.4b828cc4@dhcp-lab-109.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615103640.4b828cc4@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15, Stanislaw Gruszka wrote:
>
> Two fixes related with posix-cpu-timers

I think both patches are good.

But, to avoid the possible confusion, the second one does not fix any bug.

Oleg.

