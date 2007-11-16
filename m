Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbXKPTyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbXKPTyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbXKPTyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:54:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbXKPTyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:54:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Kees Cook <kees@ubuntu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wait_task_stopped: don't use task_pid_nr_ns() lockless
In-Reply-To: Oleg Nesterov's message of  Friday, 16 November 2007 20:24:08 +0300 <20071116172408.GA7293@tv-sign.ru>
References: <20071116172408.GA7293@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071116195407.E70A526F8BA@magilla.localdomain>
Date: Fri, 16 Nov 2007 11:54:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.


Thanks,
Roland
