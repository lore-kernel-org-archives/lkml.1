Return-Path: <linux-kernel-owner+w=401wt.eu-S1762970AbXHEUsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762970AbXHEUsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759138AbXHEUsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:48:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759333AbXHEUsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:48:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zap_other_threads: don't optimize thread_group_empty() case
In-Reply-To: Oleg Nesterov's message of  Sunday, 5 August 2007 19:36:03 +0400 <20070805153603.GA2782@tv-sign.ru>
X-Windows: garbage at your fingertips.
Message-Id: <20070805204703.468DE4D04C4@magilla.localdomain>
Date: Sun,  5 Aug 2007 13:47:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine to me.

Thanks,
Roland
