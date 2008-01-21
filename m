Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbYAUAxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbYAUAxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 19:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYAUAwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 19:52:55 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47942 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697AbYAUAwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 19:52:54 -0500
Date: Mon, 21 Jan 2008 09:52:52 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Development release 0.1 of the LatencyTOP tool
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4790E3A6.7060807@linux.intel.com>
References: <4790E3A6.7060807@linux.intel.com>
Message-Id: <20080121094546.8FC5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

> The Intel Open Source Technology Center is pleased to announce the
> release of version 0.1 of LatencyTOP, a tool for developers to visualize
> system latencies.

Interesting.

at least, I will use for fixed page lock contension :)

if possible, I want some /proc/lock_stat feature.
i.e. holding time(avg, max), contention target ip...

and, this patche become more powerful if spinlock change sleepable patch applied.
(may be, rt guy have it)


- kosaki


