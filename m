Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbXKZTOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbXKZTOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXKZTOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:14:09 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:23862 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbXKZTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:14:08 -0500
Date: Mon, 26 Nov 2007 11:13:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1
Message-Id: <20071126111320.69d0aead.randy.dunlap@oracle.com>
In-Reply-To: <20071120204525.ff27ac98.akpm@linux-foundation.org>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 20:45:25 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm1/

allnoconfig on x86_64 gives:

arch/x86/mm/init_64.c:84: error: implicit declaration of function 'pfn_valid'
mm/page_alloc.c:2533: error: implicit declaration of function 'pfn_valid'
mm/vmstat.c:518: error: implicit declaration of function 'pfn_valid'
mm/memory.c:400: error: implicit declaration of function 'pfn_valid'
drivers/char/mem.c:312: error: implicit declaration of function 'pfn_valid'


---
~Randy
