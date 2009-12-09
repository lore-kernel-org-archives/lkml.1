Return-Path: <linux-kernel-owner+w=401wt.eu-S966957AbZLIAHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966957AbZLIAHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 19:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966789AbZLIAHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 19:07:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965731AbZLIAHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 19:07:52 -0500
Message-ID: <4B1EEA51.8000600@redhat.com>
Date: Tue, 08 Dec 2009 22:07:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andy Walls <awalls@radix.net>, Jarod Wilson <jarod@wilsonet.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net, jarod@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org> <m3k4xe7dtz.fsf@intrepid.localdomain> <4B0E8B32.3020509@redhat.com> <1259264614.1781.47.camel@localhost> <6B4C84CD-F146-4B8B-A8BB-9963E0BA4C47@wilsonet.com> <1260240142.3086.14.camel@palomino.walls.org> <4B1E394A.1090807@redhat.com> <1260276412.3094.17.camel@palomino.walls.org> <20091208171931.GE14143@core.coreip.homeip.net>
In-Reply-To: <20091208171931.GE14143@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:

> I am a resonable guy ;) In cases when we can certainly say that there
> are 2 separate remotes (and we know characteristics somehow) we need to
> create 2 input devices. Otherwise we can't ;)
 
Only on very few specific cases (a few protocols), you can be (almost) sure.
Even on this case, universal remotes can fake another IR.

Cheers,
Mauro.
