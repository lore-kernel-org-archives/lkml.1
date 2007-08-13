Return-Path: <linux-kernel-owner+w=401wt.eu-S936531AbXHMFXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936531AbXHMFXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 01:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbXHMFXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 01:23:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45575 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbXHMFXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 01:23:21 -0400
Date: Sun, 12 Aug 2007 22:29:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2 (libertas)
Message-Id: <20070812222906.e6510c4b.randy.dunlap@oracle.com>
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007 22:42:54 -0700 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm2/
> 
> - Various problems from 2.6.23-rc2-mm1 were fixed

libertas wireless warnings on x86_64:

drivers/net/wireless/libertas/if_cs.c:462: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
drivers/net/wireless/libertas/if_cs.c:538: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
