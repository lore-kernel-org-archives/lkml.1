Return-Path: <linux-kernel-owner+w=401wt.eu-S965297AbXCSWsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965297AbXCSWsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 18:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965330AbXCSWsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 18:48:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965297AbXCSWsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 18:48:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
X-Fcc: ~/Mail/utrace
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ptrace needs PROC_FS
In-Reply-To: Randy Dunlap's message of  Monday, 19 March 2007 15:26:16 -0700 <20070319152616.d0857587.randy.dunlap@oracle.com>
X-Windows: simplicity made complex.
Message-Id: <20070319224847.6FAB71801C5@magilla.sf.frob.com>
Date: Mon, 19 Mar 2007 15:48:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, that Kconfig change seems like the simplest solution for this.


Thanks,
Roland
