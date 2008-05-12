Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbYELKBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbYELKBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759308AbYELKBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:01:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50804 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997AbYELKBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:01:23 -0400
Date: Mon, 12 May 2008 12:08:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Message-ID: <20080512100846.GI31954@one.firstfloor.org>
References: <20080510030831.796641881@sgi.com> <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org> <20080510221515.3540a6cc@bree.surriel.com> <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com> <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Christoph fixed a tbench regression that was in the same ballpark as
> the TPC regression reported by Matthew which is why we've asked the
> Intel folks to re-test. But yeah, we're working on it.

What are your plans to fix it?

-Andi
