Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbZEAL7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbZEAL7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZEAL7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:59:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47232 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbZEAL7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:59:31 -0400
Date: Fri, 1 May 2009 13:58:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/11] section name cleanup for x86
Message-ID: <20090501115849.GB24706@elte.hu>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tim Abbott <tabbott@MIT.EDU> wrote:

> This patch series cleans up the section names on the x86
> architecture.  It requires the architecture-independent macro
> definitions from this patch series:
> 
> <http://www.spinics.net/lists/mips/msg33499.html>

Hm, we cannot pick the x86 bits up into the x86 tree without having 
these macros upstream first. So those macros need acks from Sam and 
maybe Linus will take them out of order. (they are pure additions so 
they look fairly safe and uncontroversial)

	Ingo
