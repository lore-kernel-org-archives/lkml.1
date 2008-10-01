Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYJARju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYJARju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 13:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYJARjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 13:39:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbYJARjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 13:39:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [RFC patch 0/3] signals: add rt_tgsigqueueinfo syscall V2
In-Reply-To: Thomas Gleixner's message of  Wednesday, 1 October 2008 10:01:30 -0000 <20081001095204.343984413@linutronix.de>
References: <20081001095204.343984413@linutronix.de>
Emacs: featuring the world's first municipal garbage collector!
Message-Id: <20081001173933.54D0015427F@magilla.localdomain>
Date: Wed,  1 Oct 2008 10:39:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not that I tested it or anything, but this gets a theoretical ACK from me.

Thanks,
Roland
