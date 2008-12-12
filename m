Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbYLLVAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbYLLVAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:00:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYLLU7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:59:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:9808 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYLLU7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:59:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oJ2qFX38lhfrTEB6e5382ciO1XShtk+0vwIyLw+AQhNZX5ry384y25et69XBhiiBn6
         B1Nf65dq2qe9nfVA0wXFYsYDy9mbQ2eki2Ns7Mevh+KTPhluAwGr5jYQSVLaTrQLzt+J
         6lBWNJWnNzgy0YDSVsqy9nyGxCoTR1KbLPcQk=
Date: Fri, 12 Dec 2008 23:59:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       fweisbec <fweisbec@gmail.com>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
Message-ID: <20081212205949.GB28554@localhost>
References: <20081212184136.GB14192@localhost> <1229113167.32623.12.camel@localhost.localdomain> <20081212204724.GA26194@localhost> <alpine.DEB.1.10.0812121552360.19351@gandalf.stny.rr.com> <20081212205729.GA28554@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212205729.GA28554@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Fri, Dec 12, 2008 at 11:57:29PM +0300]
| [Steven Rostedt - Fri, Dec 12, 2008 at 03:52:56PM -0500]
| | 
| ... 
| | You can put them in arch/x86/include/asm/ftrace.h That's assembly safe.
| | 
| | -- Steve
| | 
| 
| Yep, while you were typing the message I was testing the change :)
| Do you like it?
| 
| 		- Cyrill -

By "testing" I mean "to compare objdump output".

		- Cyrill -
