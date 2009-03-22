Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZCVWYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZCVWYa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 18:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbZCVWYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 18:24:19 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:36461 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751719AbZCVWYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 18:24:19 -0400
Date: Sun, 22 Mar 2009 23:27:32 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Rui Santos <rsantos@grupopie.com>,
       Michael =?unknown-8bit?B?QsODwrxrZXI=?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Message-ID: <20090322222732.GA25563@electric-eye.fr.zoreil.com>
References: <200903041828.49972.m.bueker@berlin.de> <200903222219.50112.mb@bu3sch.de> <20090322220032.GA23091@electric-eye.fr.zoreil.com> <200903222309.58116.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903222309.58116.mb@bu3sch.de>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch <mb@bu3sch.de> :
[...]
> How do I find out? I don't find "XID" in the kernel log.

Check the log level ?

[...]
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:00:0a.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
r8169 0000:00:0a.0: no PCI Express capability
eth2: RTL8110s at 0xf8992400, 00:09:5b:bc:e9:9e, XID 04000000 IRQ 17

-- 
Ueimor
