Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbZK3Ui4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbZK3Ui4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZK3Ui4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:38:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49498
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbZK3Uiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:38:55 -0500
Date: Mon, 30 Nov 2009 12:39:01 -0800 (PST)
Message-Id: <20091130.123901.09751811.davem@davemloft.net>
To: ralf@linux-mips.org
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, acme@redhat.com,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 1/1] MIPS: Wire up recvmmsg syscall
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091130200319.GA26639@linux-mips.org>
References: <1259610615-23996-1-git-send-email-acme@infradead.org>
	<20091130200319.GA26639@linux-mips.org>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ralf Baechle <ralf@linux-mips.org>
Date: Mon, 30 Nov 2009 20:03:19 +0000

> On Mon, Nov 30, 2009 at 05:50:15PM -0200, Arnaldo Carvalho de Melo wrote:
> 
>> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>> 
>> Cc: Ralf Baechle <ralf@linux-mips.org>
>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>> ---
>>  arch/mips/include/asm/unistd.h |   15 +++++++++------
>>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> Looks good.  Dave, wanna merge this through the netdev tree?
> 
> Acked-by: Ralf Baechle <ralf@linux-mips.org>

Sure, I'll take it there.
