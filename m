Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab0CHMOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 07:14:48 -0500
Received: from ns.penguin.cz ([84.21.108.25]:53332 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab0CHMOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 07:14:42 -0500
X-Greylist: delayed 1565 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 07:14:42 EST
Subject: Re: bit errors on spitz
From: Stanislav Brabec <utx@penguin.cz>
To: Cyril Hrubis <metan@ucw.cz>
Cc: Pavel Machek <pavel@ucw.cz>, Eric Miao <eric.y.miao@gmail.com>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com,
       zaurus-devel@www.linuxtogo.org
In-Reply-To: <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>
References: <20100305212708.GC21773@elf.ucw.cz>
	 <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>
	 <20100308072858.GA29939@atrey.karlin.mff.cuni.cz>
	 <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Mon, 08 Mar 2010 12:48:36 +0100
Message-ID: <1268048916.6477.9.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyril Hrubis wrote:

> Well I've seen empty lines when editing file with vim

And I have seen:

- Unreproducible SIGSEGV of gcc (while Wi-Fi connection over CF card was
  running).
- Unreproducible SIGSEGV of opkg (downloading via Wi-Fi connection over
  CF card).
- Unreproducible SIGSEGV of rm (called from find command launched via
  ssh, networking via Wi-Fi connection over CF card).
  (Hint: Tasks above are HDD-intensive.)
- Lost blocks while copying from CF to SD.
- Lost blocks while copying from HDD to SD.
- Lost blocks while copying from CF to USB flash stick.
- And I see display noise while CF Wi-Fi card is active.

These problems appear in all kernels, at least since 2.6.26.

There is no note in the syslog.


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

