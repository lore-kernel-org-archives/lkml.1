Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbXICEc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbXICEc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 00:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbXICEcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 00:32:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:34741 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbXICEcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 00:32:48 -0400
Date: Sun, 2 Sep 2007 21:30:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: 2.6.23-rc4-mm1
Message-Id: <20070902213049.45804afd.randy.dunlap@oracle.com>
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
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

On Fri, 31 Aug 2007 21:58:22 -0700 Andrew Morton wrote:

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/
> 
> Changes since 2.6.23-rc3-mm1:
> 
>  git-watchdog.patch


on x86_64:
drivers/watchdog/core/watchdog_dev.c:84: warning: format '%i' expects type 'int', but argument 5 has type 'size_t'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
