Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbXHAUlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbXHAUlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbXHAUlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:41:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52852 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbXHAUlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:41:03 -0400
Date: Wed, 1 Aug 2007 13:40:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2
Message-Id: <20070801134055.7862b95e.akpm@linux-foundation.org>
In-Reply-To: <12639.1186000208@turing-police.cc.vt.edu>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	<12639.1186000208@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007 16:30:08 -0400
Valdis.Kletnieks@vt.edu wrote:

> As an aside, it looks like bits&pieces of dynticks-for-x86_64 are in there.
> In particular, x86_64-enable-high-resolution-timers-and-dynticks.patch is in
> there, adding a menu that depends on GENERIC_CLOCKEVENTS, but then nothing
> in the x86_64 tree actually *sets* it.  There's a few other dynticks-related
> prep patches in there as well.  Does this mean it's back to "coming soon to
> a CPU near you" status? :)

I've lost the plot on that stuff: I'm just leaving things as-is for now,
wait for Thomas to return from vacation so we can have another run at it.
