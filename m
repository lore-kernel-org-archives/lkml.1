Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbYKQV3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbYKQV3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbYKQV3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:29:08 -0500
Received: from vena.lwn.net ([206.168.112.25]:33485 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbYKQV3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:29:08 -0500
Date: Mon, 17 Nov 2008 14:28:51 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, paulmck@linux.vnet.ibm.com,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
 V2
Message-ID: <20081117142851.356e4ff3@tpl>
In-Reply-To: <49216A44.4070203@cn.fujitsu.com>
References: <4917A8E7.8060801@cn.fujitsu.com>
	<20081110184520.GC6685@linux.vnet.ibm.com>
	<4918D7E4.9030107@cn.fujitsu.com>
	<20081111010331.GF6685@linux.vnet.ibm.com>
	<491B9581.2080201@cn.fujitsu.com>
	<20081113173114.GA6788@linux.vnet.ibm.com>
	<491CCE58.1040701@cn.fujitsu.com>
	<20081114021152.GF6788@linux.vnet.ibm.com>
	<491D2B16.8060000@cn.fujitsu.com>
	<20081114122543.0578bd5e@bike.lwn.net>
	<20081115203942.GA7108@linux.vnet.ibm.com>
	<49216A44.4070203@cn.fujitsu.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 20:57:40 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Is there any problem for this document added to kernel?

No problem; I'll get it queued up for 2.6.29 unless somebody else gets
it there first.

jon
