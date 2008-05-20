Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbYETAX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbYETAX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbYETAXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:23:51 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45648 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbYETAXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:23:50 -0400
Subject: Re: 2.6.25.4-rt2
From: Kasper Sandberg <lkml@metanurb.dk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1211237032.14697.76.camel@localhost.localdomain>
References: <1211237032.14697.76.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 20 May 2008 02:19:17 +0200
Message-Id: <1211242757.19845.48.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 18:43 -0400, Steven Rostedt wrote:
> We are pleased to announce the 2.6.25.4-rt2 tree, which can be
<snip>

I have just tested this, and it breaks jackd horribly, no matter the
settings, jack ALWAYS underruns.

What information do you need me to provide?

> 
> 
> 
> -- Steve
> 
> 	
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

