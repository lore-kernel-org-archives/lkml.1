Return-Path: <linux-kernel-owner+w=401wt.eu-S934835AbYEUA6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934835AbYEUA6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764223AbYEUA6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:58:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934128AbYEUA6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:58:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] signals: collect_signal: simplify the "still_pending" logic
In-Reply-To: Oleg Nesterov's message of  Saturday, 17 May 2008 19:14:24 +0400 <20080517151424.GA9508@tv-sign.ru>
References: <20080517151424.GA9508@tv-sign.ru>
X-Zippy-Says: My mind is a potato field...
Message-Id: <20080521005815.74E9D26FA1C@magilla.localdomain>
Date: Tue, 20 May 2008 17:58:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Factor out sigdelset() calls and remove the "still_pending" variable.

Acked-by: Roland McGrath <roland@redhat.com>
