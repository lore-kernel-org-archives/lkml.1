Return-Path: <linux-kernel-owner+w=401wt.eu-S936426AbXGZUgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936426AbXGZUgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762879AbXGZUgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:36:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51650 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758602AbXGZUgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:36:40 -0400
Date: Thu, 26 Jul 2007 13:35:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, wwoods@redhat.com
Subject: Re: [PATCH] core_pattern: Add ability for core_pattern to parse
 arguments when pattern is a pipe
Message-Id: <20070726133536.f8bb16cc.akpm@linux-foundation.org>
In-Reply-To: <20070726202018.GA10490@hmsreliant.homelinux.net>
References: <20070726173923.GA5701@hmsreliant.homelinux.net>
	<20070726114832.faf14bb0.akpm@linux-foundation.org>
	<20070726193145.GC5701@hmsreliant.homelinux.net>
	<20070726124731.0b7c4ecc.akpm@linux-foundation.org>
	<20070726202018.GA10490@hmsreliant.homelinux.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 16:20:18 -0400 Neil Horman <nhorman@tuxdriver.com> wrote:

> If you'd like to back them all out, I have them
> all in a git tree here, and I can repost (say early next week when I finish
> local testing) as a patch sequence, with all my screw-ups properly fixed,
> and with an appropriate changelog describing the whole sequence.

hm, I have six fixes here against
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
and I always worry that some might get lost.

How many more patches have you after this one?
