Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbYHHR4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbYHHR4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYHHR4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:56:08 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:1594 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbYHHR4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:56:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkFAJ8lnEhR8DtG/2dsb2JhbACBXKs6
Date: Fri, 8 Aug 2008 19:56:05 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Adrian Bunk <bunk@kernel.org>
Cc: Alan Cox <alan@redhat.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] fix watchdog/txx9wdt.c compilation
Message-ID: <20080808175605.GE2773@infomag.infomag.iguana.be>
References: <20080808151846.GA14495@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808151846.GA14495@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

> This patch fixes the following compile error caused by
> commit 8dc244f7deac4c0e95ce0ffd26f494bb6e1534c0
> ([WATCHDOG 48/57] txx9: Fix locking, switch to unlocked_ioctl):

Will also be added.

Kind regards,
Wim.

