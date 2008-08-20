Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYHTRvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYHTRvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYHTRv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:51:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbYHTRv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:51:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RESEND] posix-timers: simplify de_thread()->exit_itimers() path
In-Reply-To: Oleg Nesterov's message of  Wednesday, 20 August 2008 20:54:42 +0400 <20080820165442.GA1459@tv-sign.ru>
References: <20080820165442.GA1459@tv-sign.ru>
Emacs: (setq software-quality (/ 1 number-of-authors))
Message-Id: <20080820175119.E7877154218@magilla.localdomain>
Date: Wed, 20 Aug 2008 10:51:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That looks fine to me.

Thanks,
Roland
