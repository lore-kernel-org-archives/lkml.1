Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbXKJOpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbXKJOpv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 09:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbXKJOpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 09:45:43 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:49170 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113AbXKJOpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 09:45:42 -0500
X-Belgacom-Dynamic: yes
Date: Sat, 10 Nov 2007 15:45:35 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       michael.frysinger@analog.com, vapier.adi@gmail.com
Subject: Re: [PATCH 2/5] Watchdog: bfin_wdt, remove SPIN_LOCK_UNLOCKED
Message-ID: <20071110144535.GA2654@infomag.infomag.iguana.be>
References: <4827138842526222333@pripojeni.net> <7981323273222714582@pripojeni.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7981323273222714582@pripojeni.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> bfin_wdt, remove SPIN_LOCK_UNLOCKED
> 
> SPIN_LOCK_UNLOCKED is deprecated, use DEFINE_SPINLOCK instead

Added to linux-2.6-watchdog-mm git tree.

Greetings,
Wim.

