Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYGMWql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYGMWql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 18:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYGMWqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 18:46:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbYGMWqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 18:46:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] coredump: make mm->core_state visible to ->core_dump()
In-Reply-To: Oleg Nesterov's message of  Sunday, 13 July 2008 21:22:56 +0400 <20080713172256.GA28764@tv-sign.ru>
References: <20080713172256.GA28764@tv-sign.ru>
Emacs: no job too big... no job.
Message-Id: <20080713224626.5941F1541F8@magilla.localdomain>
Date: Sun, 13 Jul 2008 15:46:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

These four patches look good to me.

Thanks,
Roland
