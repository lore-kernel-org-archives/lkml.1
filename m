Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbXKJOq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbXKJOq3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 09:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXKJOqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 09:46:20 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:49862 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbXKJOqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 09:46:19 -0500
X-Belgacom-Dynamic: yes
Date: Sat, 10 Nov 2007 15:46:17 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] Sbus: cpwatchdog, remove SPIN_LOCK_UNLOCKED
Message-ID: <20071110144617.GB2654@infomag.infomag.iguana.be>
References: <4827138842526222333@pripojeni.net> <1482721921242938628@pripojeni.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482721921242938628@pripojeni.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> cpwatchdog, remove SPIN_LOCK_UNLOCKED
> 
> SPIN_LOCK_UNLOCKED is deprecated, use __SPIN_LOCK_UNLOCKED with an unique
> name instead

Added to linux-2.6-watchdog-mm git tree.

Greetings,
Wim.

