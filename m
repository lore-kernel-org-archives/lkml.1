Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbZFPKZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbZFPKZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZFPKZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:25:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZFPKZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:25:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
X-Fcc: ~/Mail/linus
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 0/8] clean up vdso-layout.lds.S
In-Reply-To: Petr Tesarik's message of  Tuesday, 16 June 2009 12:12:02 +0200 <1245147122.17481.205.camel@nathan.suse.cz>
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
	<20090612180626.GB18203@uranus.ravnborg.org>
	<1245147122.17481.205.camel@nathan.suse.cz>
X-Windows: form follows malfunction.
Message-Id: <20090616102248.88E021B9@magilla.sf.frob.com>
Date: Tue, 16 Jun 2009 03:22:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What shall I do? Since Roland has some good ideas for improvement,
> should I post a new patch series (v3), or should I add on top of the
> acked one?

I'd prefer to see a replacement series.


Thanks,
Roland
