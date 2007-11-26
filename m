Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbXKZHvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbXKZHvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 02:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbXKZHvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 02:51:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbXKZHvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 02:51:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 23/27] x86: debugctlmsr kconfig
In-Reply-To: Denys Vlasenko's message of  Sunday, 25 November 2007 17:09:01 -0800 <200711251709.01304.vda.linux@googlemail.com>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
	<20071125220802.76C2F26F8C5@magilla.localdomain>
	<200711251709.01304.vda.linux@googlemail.com>
X-Zippy-Says: Half a mind is a terrible thing to waste!
Message-Id: <20071126075131.95A0226F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 23:51:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Why is it defined in configuration system instead of some *.h file?

That seems to be existing practice for this sort of thing.
I just followed what I saw.


Thanks,
Roland
