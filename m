Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbXH1K0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbXH1K0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbXH1K0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:26:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbXH1K0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:26:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wait_task_stopped/continued: remove unneeded p->signal != NULL check
In-Reply-To: Oleg Nesterov's message of  Tuesday, 28 August 2007 14:18:35 +0400 <20070828101835.GA369@tv-sign.ru>
Emacs: the only text editor known to get indigestion.
Message-Id: <20070828102522.335C14D04CC@magilla.localdomain>
Date: Tue, 28 Aug 2007 03:25:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.


Thanks,
Roland
