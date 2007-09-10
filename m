Return-Path: <linux-kernel-owner+w=401wt.eu-S964876AbXIJTWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876AbXIJTWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759419AbXIJTWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:22:07 -0400
Received: from www.osadl.org ([213.239.205.134]:57532 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758952AbXIJTWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:22:06 -0400
Subject: Re: [RFC] kbuild - introduce vdir to make life easier for x86_64
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070910191138.GA31541@uranus.ravnborg.org>
References: <20070910191138.GA31541@uranus.ravnborg.org>
Content-Type: text/plain
Date: Mon, 10 Sep 2007 21:22:01 +0200
Message-Id: <1189452121.25767.42.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

On Mon, 2007-09-10 at 21:11 +0200, Sam Ravnborg wrote:
> One of the complaints raised about the current x86_64
> Makfiles are the ugliness needed to reuse code from i386.
> Andi asked me if we could do something in kbuild to make
> this less ugly and below are the hack I could come up with.

while in general this is definitely a nice change, it does not really
solve the real problem of code scattered across two architectures. The
Makefile polishing is the least thing we care about.

Thanks,

	tglx




