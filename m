Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0APRAd (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 12:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793Ab0APRAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 12:00:32 -0500
Received: from ns.penguin.cz ([84.21.108.25]:53645 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab0APRAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 12:00:31 -0500
Subject: Re: [suspend/resume] Re: userspace notification from module
From: Stanislav Brabec <utx@penguin.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
        Bart?omiej Zimo? <uzi18@o2.pl>, Andy Walls <awalls@radix.net>,
        Daniel Borkmann <danborkmann@googlemail.com>,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com,
        zaurus-devel@www.linuxtogo.org
In-Reply-To: <f17812d71001151900x35959e88jc5f275573ee02177@mail.gmail.com>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl>
	 <201001091440.46434.rjw@sisk.pl>  <20100115200310.GG1345@ucw.cz>
	 <201001152314.30355.rjw@sisk.pl>
	 <f17812d71001151900x35959e88jc5f275573ee02177@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Sat, 16 Jan 2010 18:00:58 +0100
Message-Id: <1263661258.6596.10.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Miao wrote:

> And the other way we may need to look into what API the current userland
> apps on zaurus is depending on this 2.4 compatibility and make changes
> slowly to those apps.

I guess that 2.4 compatibility is not an issue. Most modern Zaurus
distributions are even unable to run Sharp ROM compatible binaries.

Distributions either stay on 2.4 kernel or use modern systems based on
modern kernel 2.6 API.

Distributions that decided to migrate to kernel 2.6 are far from
finished state. Any change that allows to use modern applications using
standard kernel API is welcome.


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

