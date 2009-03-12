Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbZCLHfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbZCLHfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbZCLHfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:35:01 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58662 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZCLHfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:35:00 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH 0/4] [GIT PULL] memory saving ring buffer for tip/tracing/ftrace
Cc: kosaki.motohiro@jp.fujitsu.com, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pekka Paalanen <pq@iki.fi>,
       Neil Horman <nhorman@redhat.com>
In-Reply-To: <20090312080758.4a14d5b4@mjolnir.ossman.eu>
References: <20090312023720.144716747@goodmis.org> <20090312080758.4a14d5b4@mjolnir.ossman.eu>
Message-Id: <20090312163414.43B4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 12 Mar 2009 16:34:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How difficult is it to apply this to 2.6.27? Fedora is still on that
> kernel and it would be nice if I could get my memory back on a
> distribution kernel. :)

Difficult.
but you can use "trace_entries=1" kernel boot parameter :)


