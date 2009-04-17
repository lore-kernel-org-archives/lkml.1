Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbZDQLZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbZDQLZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 07:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932081AbZDQLY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 07:24:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55893 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbZDQLY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 07:24:56 -0400
Message-ID: <49E866F2.7020407@jp.fujitsu.com>
Date: Fri, 17 Apr 2009 20:24:34 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [0/28] x86: MCE: Feature series for 2.6.31
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Various new Intel x86 machine check features, including initial support
> for machine check recovery and new status bits. The actual machine check
> recovery requires some generic VM changes, which will be posted in a separate
> series ("POISON series") This series can be applied without the POISON
> series and POISON requires these patches.
> 
> Especially the broadcast and early nowayout patches are fairly important for 
> Nehalem CPUs, without them machine checks are often incorrectly reported
> due to the shared bank topology of the system.
> 
> -Andi

Andi, could you divide this series into "cleanups" and "features"?
Or May I help you?


Thanks,
H.Seto


