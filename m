Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbYJ0KOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbYJ0KOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYJ0KOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:14:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43385 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbYJ0KOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:14:15 -0400
Date: Mon, 27 Oct 2008 11:13:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.28-rc1++ resend] docbooks: fix fatal filename errors
Message-ID: <20081027101355.GJ8116@elte.hu>
References: <20081025172436.aaac22d4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025172436.aaac22d4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0197]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix docbook fatal errors (file location changed):
> 
> docproc: lin2628-rc1/include/asm-x86/io_32.h: No such file or directory
> make[1]: *** [Documentation/DocBook/deviceiobook.xml] Error 1
> 
> docproc: lin2628-rc1/include/asm-x86/atomic_32.h: No such file or directory
> make[1]: *** [Documentation/DocBook/kernel-api.xml] Error 1
> 
> docproc: lin2628-rc1/include/asm-x86/mca_dma.h: No such file or directory
> make[1]: *** [Documentation/DocBook/mcabook.xml] Error 1
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

a belated Acked-by - thanks Randy!

	Ingo
