Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbYIXRMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbYIXRMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 13:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYIXRMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 13:12:30 -0400
Received: from flusers.ccur.com ([12.192.68.2]:35941 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751318AbYIXRMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 13:12:30 -0400
Date: Wed, 24 Sep 2008 13:11:43 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG, TEST PATCH] stallout race between SIGCONT and SIGSTOP
Message-ID: <20080924171143.GA18733@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20080923155331.GA20380@tsunami.ccur.com> <20080923163530.GA656@tv-sign.ru> <20080924150541.GA119@tv-sign.ru> <20080924151933.GA17531@tsunami.ccur.com> <20080924155611.GA5334@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924155611.GA5334@tv-sign.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 11:56:11AM -0400, Oleg Nesterov wrote:
> Confused. Do you agree the kernel is not buggy?

I agree with you that what the kernel is doing now is correct.
Joe
