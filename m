Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbYG3EHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbYG3EHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 00:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYG3EH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 00:07:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbYG3EHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 00:07:25 -0400
Date: Tue, 29 Jul 2008 21:06:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: bad dereference in sched_mc_power_savings_store()
Message-Id: <20080729210657.7839239d.akpm@linux-foundation.org>
In-Reply-To: <20080724202634.GH20882@one.firstfloor.org>
References: <20080724120217.163a03f3@mjolnir.drzeus.cx>
	<20080724202634.GH20882@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 22:26:34 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <andi@firstfloor.org>
> Author: Andi Kleen <ak@gargoyle.(none)>
>     Signed-off-by: Andi Kleen <ak@linux.intel.com>

Multiple personality disorder.  Which is your preferred address for git
commits?

Nobody seems to have merged this patch into anything yet.  I guess I
can take care of that.

