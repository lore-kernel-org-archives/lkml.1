Return-Path: <linux-kernel-owner+w=401wt.eu-S1423099AbXBUXfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423099AbXBUXfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945913AbXBUXfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:35:21 -0500
Received: from mailrly05.isp.novis.pt ([195.23.133.215]:49184 "EHLO
	mailrly05.isp.novis.pt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423099AbXBUXfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:35:21 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Feb 2007 18:35:20 EST
Message-ID: <45DCD61B.7000804@vgertech.com>
Date: Wed, 21 Feb 2007 23:30:35 +0000
From: Nuno Silva <nuno.silva@vgertech.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060812)
MIME-Version: 1.0
To: "Michael K. Edwards" <medwards.linux@gmail.com>
CC: davids@webmaster.com, v j <vj.linux@gmail.com>, trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: GPL vs non-GPL device drivers
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>	 <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com> <f2b55d220702211408r7954d5dar2c59e1e679316811@mail.gmail.com>
In-Reply-To: <f2b55d220702211408r7954d5dar2c59e1e679316811@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael K. Edwards wrote:
> Actually, it's quite clear under US law what a derivative work is and
> what rights you need to distribute it, and equally clear that
> compiling code does not make a "translation" in a copyright sense.
> Read Micro Star v. Formgen -- it's good law and it's funny and
> readable.

Hello.

[Sorry for deleting the rest of the email but it was quite large]

I can see that your argument is all about the defenition of a
"derivative work".

We all know that #include <anything.h> is mostly non copyrightable, so I
mostly agree that some - very very simple - modules may not need to
include the source when distributing the resulting module.ko. (need =
from a legal standpoint... The intended spirit of the GPL is another story)

In this context what do you think about porting Linux to another arch?
Does the people porting the OS needs to distribute the source with the
[compiled] kernel?

(Yes, it's a trick question)

IANAL too.

Regards,
Nuno Silva

