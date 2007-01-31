Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbXAaAF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbXAaAF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 19:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbXAaAF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 19:05:57 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:24570 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbXAaAF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 19:05:56 -0500
In-Reply-To: <20070129234139.2443391b.akpm@osdl.org>
References: <Pine.LNX.4.64.0701292341070.32393@localhost.localdomain> <20070130055556.GA20699@in.ibm.com> <8DAAF0FE-E76A-4C1F-94B7-36BE839EA6BE@kernel.crashing.org> <112DEBE1-0765-40DC-B8FD-75DE7336312A@kernel.crashing.org> <20070129234139.2443391b.akpm@osdl.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <28D7E684-12A5-43C0-AA2C-2D4E02409984@kernel.crashing.org>
Cc: ananth@in.ibm.com, Linux Kernel list <linux-kernel@vger.kernel.org>,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       "David S. Miller" <davem@davemloft.net>,
       Paul Mackerras <paulus@samba.org>, masami.hiramatsu.pt@hitachi.com
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] kprobes: Fix compiler warning
Date: Tue, 30 Jan 2007 18:04:52 -0600
To: Andrew Morton <akpm@osdl.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30, 2007, at 1:41 AM, Andrew Morton wrote:

> On Tue, 30 Jan 2007 01:12:17 -0600
> Kumar Gala <galak@kernel.crashing.org> wrote:
>
>> What are your thoughts on forward Masami patch to Linus for 2.6.20
>> since it fixes a real bug on PPC?
>
> I bumped it up into the for-2.6.20 slot.

thanks.

- k

