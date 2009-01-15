Return-Path: <linux-kernel-owner+w=401wt.eu-S934336AbZAOXSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336AbZAOXSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933581AbZAOXSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:18:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933557AbZAOXSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:18:03 -0500
Subject: Re: [GIT PULL] scheduler fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090115220809.GA7793@elte.hu>
References: <20090115220809.GA7793@elte.hu>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 00:17:51 +0100
Message-Id: <1232061471.8870.77.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 23:08 +0100, Ingo Molnar wrote:

> Peter Zijlstra (4):
>       sched: fix bandwidth validation for UID grouping
>       sched: SCHED_IDLE weight change
>       sched: SCHED_OTHER vs SCHED_IDLE isolation
>       sched: fix update_min_vruntime

Drad, 2 of those were from Mike and quilt ate the From :-(



