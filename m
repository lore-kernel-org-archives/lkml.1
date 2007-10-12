Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbXJLV3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbXJLV3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbXJLV3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:29:43 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60279 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985AbXJLV3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:29:43 -0400
Date: Fri, 12 Oct 2007 23:31:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.git build error
Message-ID: <20071012213114.GA24016@uranus.ravnborg.org>
References: <1192164538.10413.3.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192164538.10413.3.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 06:48:58AM +0200, Mike Galbraith wrote:
> Greetings,
> 
> Freshly pulled 2.6.23.git failed to build:
> 
> make[1]: *** No rule to make target `arch/x86/kernel/asm-offsets.c', needed by `arch/x86/kernel/asm-offsets.s'.  Stop.
> make: *** [prepare0] Error 2
> make: *** Waiting for unfinished jobs....

You are the only reporter of this bug.
I do not see it here and I have the asm-offset.c file.

Have you figured out more about this bug?
For now I assume you did something bad when you updated your kernel tree.
Could  you as minimum check the content of the arch/x86/kernel/ directory.

Thanks,
	Sam
