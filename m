Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbXICTNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbXICTNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 15:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbXICTNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 15:13:06 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3322 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbXICTNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 15:13:05 -0400
Date: Mon, 3 Sep 2007 21:13:33 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Simple Really Fair Scheduler
In-Reply-To: <20070903185403.GA23479@elte.hu>
Message-ID: <Pine.LNX.4.64.0709032106070.1817@scrub.home>
References: <20070902120154.GA23769@elte.hu> <Pine.LNX.4.64.0709032030320.1817@scrub.home>
 <20070903185403.GA23479@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 3 Sep 2007, Ingo Molnar wrote:

> If this basic model is correct, we can look further.

The basic model is correct insofar I use an absolute time instead of a 
relative time, but it's not the essence of my math, so I don't quite 
understand the point of this exercise.

bye, Roman
