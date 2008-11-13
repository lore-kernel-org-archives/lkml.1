Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYKMCvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYKMCvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 21:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYKMCvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 21:51:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52593 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYKMCvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 21:51:11 -0500
Message-ID: <491B9581.2080201@cn.fujitsu.com>
Date: Thu, 13 Nov 2008 10:48:33 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
 V2
References: <49129310.5000903@cn.fujitsu.com> <20081109005159.GM6917@linux.vnet.ibm.com> <4917A8E7.8060801@cn.fujitsu.com> <20081110184520.GC6685@linux.vnet.ibm.com> <4918D7E4.9030107@cn.fujitsu.com> <20081111010331.GF6685@linux.vnet.ibm.com>
In-Reply-To: <20081111010331.GF6685@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Paul,

Could you add a RCU document about unloadable modules for kernel?

Thanx, Lai.

