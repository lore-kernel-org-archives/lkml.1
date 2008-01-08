Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbYAHVCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbYAHVCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYAHVCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:02:43 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:37169 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYAHVCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:02:42 -0500
Date: Tue, 8 Jan 2008 13:00:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7: sparc64: WARNING: at
 kernel/lockdep_proc.c:267 lockdep_stats_show()
Message-Id: <20080108130034.8ab82fb0.randy.dunlap@oracle.com>
In-Reply-To: <200801081942.17139.m.kozlowski@tuxland.pl>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	<200801081942.17139.m.kozlowski@tuxland.pl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 19:42:16 +0100 Mariusz Kozlowski wrote:

> Hello,
> 
> 	Got this when doing usual looping over /proc entries on fresh test kernel:

What is the usual looping, please?

---
~Randy
