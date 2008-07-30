Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbYG3BRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbYG3BRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYG3BRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:17:14 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:57264 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbYG3BRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:17:13 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Marco Berizzi <pupilla@hotmail.com>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: commit a29ccf6f823a84d89e1c7aaaf221cf7282022024 break console on slackware 12.1
Date: Wed, 30 Jul 2008 11:16:58 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <8ufv84tn8vih8sfuodand1kchv11jqr2n6@4ax.com>
References: <BAY103-DAV4F0ECBCAFB86B24C87D3EB2820@phx.gbl> <200807291815.13907.alistair@devzero.co.uk> <BAY103-W38794846AA924235B38E47B2820@phx.gbl> <488FAFE3.4040001@am.sony.com>
In-Reply-To: <488FAFE3.4040001@am.sony.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 17:03:47 -0700, Tim Bird <tim.bird@am.sony.com> wrote:

>Marco Berizzi wrote:
>> alistair@devzero.co.uk wrote:
>> 
>>> You don't actually say whether you had CONFIG_CONSOLE_TRANSLATIONS=y or not?
>> 
>> yes console_translation is set to yes. It cannot be changed if embedded is not
>> set.
>
>If console_translation is set to yes, the behavior should be unchanged from
>2.6.26.  Can you please send me your .config?
>
>Also, can you please describe what breakage you are seeing?

.config
  http://bugsplatter.mine.nu/test/boxen/vmware/config-2.6.27-rc1a.gz
picture: 
  http://bugsplatter.mine.nu/test/boxen/vmware/linux-2.6.27-rc1-console.jpg

Slackware-12.1 VM on WinXP vmware server 1.0.6.

Grant.
