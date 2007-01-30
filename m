Return-Path: <linux-kernel-owner+w=401wt.eu-S965413AbXA3Hlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965413AbXA3Hlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 02:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965425AbXA3Hlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 02:41:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46685 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965413AbXA3Hlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 02:41:52 -0500
Date: Mon, 29 Jan 2007 23:41:39 -0800
From: Andrew Morton <akpm@osdl.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: ananth@in.ibm.com, Linux Kernel list <linux-kernel@vger.kernel.org>,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       "David S. Miller" <davem@davemloft.net>,
       Paul Mackerras <paulus@samba.org>, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH] kprobes: Fix compiler warning
Message-Id: <20070129234139.2443391b.akpm@osdl.org>
In-Reply-To: <112DEBE1-0765-40DC-B8FD-75DE7336312A@kernel.crashing.org>
References: <Pine.LNX.4.64.0701292341070.32393@localhost.localdomain>
	<20070130055556.GA20699@in.ibm.com>
	<8DAAF0FE-E76A-4C1F-94B7-36BE839EA6BE@kernel.crashing.org>
	<112DEBE1-0765-40DC-B8FD-75DE7336312A@kernel.crashing.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 01:12:17 -0600
Kumar Gala <galak@kernel.crashing.org> wrote:

> What are your thoughts on forward Masami patch to Linus for 2.6.20  
> since it fixes a real bug on PPC?

I bumped it up into the for-2.6.20 slot.
