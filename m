Return-Path: <linux-kernel-owner+w=401wt.eu-S1762392AbYBLNFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762392AbYBLNFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbYBLNFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:05:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35265 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbYBLNFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 08:05:03 -0500
Subject: Re: [RFC][PATCH] sched: fair-group: load_balance_monitor vs wakeups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, vatsa <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1202821178.6247.21.camel@lappy>
References: <1202821178.6247.21.camel@lappy>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 14:04:42 +0100
Message-Id: <1202821482.6247.23.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 13:59 +0100, Peter Zijlstra wrote:

> +	printk(KERN_EMERG "load_balance_shares: %p %d\n", lb_monitor, state);

Uhm,.. seems I forgot to refresh after removing the debug info.. :-)

