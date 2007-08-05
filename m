Return-Path: <linux-kernel-owner+w=401wt.eu-S1762658AbXHEUrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762658AbXHEUrs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759333AbXHEUrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:47:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758553AbXHEUrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:47:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit_notify: don't take tasklist for TIF_SIGPENDING re-targeting
In-Reply-To: Oleg Nesterov's message of  Sunday, 5 August 2007 19:27:09 +0400 <20070805152709.GA2528@tv-sign.ru>
X-Windows: it could be worse, but it'll take time.
Message-Id: <20070805204733.340104D04C5@magilla.localdomain>
Date: Sun,  5 Aug 2007 13:47:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine to me.

Thanks,
Roland
