Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054Ab0AGWab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab0AGWab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696Ab0AGWab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:30:31 -0500
Received: from ns.penguin.cz ([84.21.108.25]:44634 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab0AGWaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:30:30 -0500
Subject: Re: [patch] fix strange characters in zaurus gpio .desc
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       zaurus-devel@www.linuxtogo.org, Andrew Morton <akpm@osdl.org>
In-Reply-To: <20100107203104.GA22681@elf.ucw.cz>
References: <20100107203104.GA22681@elf.ucw.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Thu, 07 Jan 2010 23:31:23 +0100
Message-Id: <1262903483.5722.7.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> From: Cyril Hrubis <metan@ucw.cz>
>     
> Somehow,
Some = my Evolution Mail

I remember that I prepared a patch and fixed capitalization of these
strings in the mail body in the last minute before sending.

> strange characters made their way zaurus gpio .desc
> fields. Fix it.
>     
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Acked-by: Stanislav Brabec <utx@penguin.cz>

Hint: If you use Evolution Mail for sending mails, never edit anything
inside inlined patch and never use old mail as a template, otherwise
Evolution Mail will include invisible characters to your mail.

Let's see whether it is fixed in the evolution-2.28.


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

