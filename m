Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZIGSvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZIGSvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 14:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZIGSvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 14:51:14 -0400
Received: from bu3sch.de ([62.75.166.246]:57987 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbZIGSvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 14:51:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Mon, 7 Sep 2009 20:51:11 +0200
User-Agent: KMail/1.9.9
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu>
In-Reply-To: <20090907182629.GA3484@elte.hu>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909072051.13748.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 September 2009 20:26:29 Ingo Molnar wrote:
> Could you profile it please? Also, what's the context-switch rate?

As far as I can tell, the broadcom mips architecture does not have profiling support.
It does only have some proprietary profiling registers that nobody wrote kernel
support for, yet.

-- 
Greetings, Michael.
