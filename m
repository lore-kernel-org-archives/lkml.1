Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbZJZQiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbZJZQiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZJZQiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:38:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbZJZQiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:38:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: nooiwa <nooiwa@miraclelinux.com>, akpm@linux-foundation.org,
       oleg@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       h-shimamoto@ct.jp.nec.com, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] show message when exceeded rlimit of pending signals
In-Reply-To: Ingo Molnar's message of  Monday, 26 October 2009 12:38:00 +0100 <20091026113800.GA9503@elte.hu>
References: <4AE1804A.2050404@miraclelinux.com>
	<20091023114600.GG5886@elte.hu>
	<4AE2A6A1.1070904@miraclelinux.com>
	<4AE2C151.8070006@miraclelinux.com>
	<20091024085848.GA23215@elte.hu>
	<4AE57745.8080701@miraclelinux.com>
	<20091026113800.GA9503@elte.hu>
Emacs: (setq software-quality (/ 1 number-of-authors))
Message-Id: <20091026163701.31E1D1E@magilla.sf.frob.com>
Date: Mon, 26 Oct 2009 09:37:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no opinion about the logging or how to enable it.

Thanks,
Roland
