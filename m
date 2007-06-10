Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbXFJU3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbXFJU3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 16:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbXFJU3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 16:29:38 -0400
Received: from mailrelay100.isp.belgacom.be ([195.238.6.81]:27774 "EHLO
	mailgate100.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbXFJU3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 16:29:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAGL8a0ZR8MuT/2dsb2JhbACBTg
Date: Sun, 10 Jun 2007 22:31:47 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 1/1] Watchdog driver for AT32AP700X devices
Message-ID: <20070610203147.GB9209@infomag.infomag.iguana.be>
References: <1181138647434-git-send-email-hcegtvedt@atmel.com> <20070607160910.34d64842.akpm@linux-foundation.org> <1181287407.28296.17.camel@localhost.localdomain> <1181301608.28296.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181301608.28296.44.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you want me to fold all five patches? original + fix1 and fix2 +
> iounmap patches.

Th original driver + the 5 fixes have been added to the linux-2.6-watchdog-mm
git tree. I'll review the driver later this week.

Greetings,
Wim.
