Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbZFWQ2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbZFWQ2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756963AbZFWQ2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:28:16 -0400
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:47857 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753990AbZFWQ2P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:28:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IPvEq4xRbpSoLvkxm+zzyFX80tApncuAtWOfhk5AidZCjfKLRr+wct2cOnWaWPqAu5KLHkQ3o8t9MD2cHxd732poNFzMv5fW9tjjjVumLSa2rYZe2oHy1+R6QB7h/Yjw;
Date: Tue, 23 Jun 2009 09:28:12 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Michel =?UTF-8?B?RMOkbnplcg==?= <michel@daenzer.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas@netline-mail2.netline.ch, Dave Airlie <airlied@linux.ie>,
       Andrew Lutomirski <luto@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jerome Glisse <jglisse@redhat.com>, dri-devel@lists.sf.net,
       Alex Deucher <alexdeucher@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] drm: previous pull req + 1.
Message-ID: <20090623092812.16dffa97@jbarnes-g45>
In-Reply-To: <20090623083944.3e86ed2e@jbarnes-g45>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	<4A3DABE1.50309@mit.edu>
	<alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	<alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	<alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	<cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	<alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
	<alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
	<4A3F3E3A.2030202@shipmail.org>
	<1245715213.4017.13.camel@pasglop>
	<alpine.LFD.2.01.0906221721450.3240@localhost.localdomain>
	<1245719079.4017.25.camel@pasglop>
	<20090622181832.771dac03@jbarnes-g45>
	<1245743280.5580.2203.camel@thor.local>
	<20090623083944.3e86ed2e@jbarnes-g45>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 08:39:44 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tue, 23 Jun 2009 09:48:00 +0200
> Michel Dänzer <michel@daenzer.net> wrote:
> > On a side note, I did precisely that about ten years ago on my
> > Amiga. :) Granted, that was using two separate framebuffer devices
> > (X glint driver on top of pm2fb, debug messages on amifb), but I
> > think even that case isn't possible ATM. I agree it would be nice,
> > though realistically there's hardly a way around a second machine
> > for graphics driver development anyway.
> 
> Oh I know, most operating systems have reasonable debugging
> facilities, and have had for a long time.  Linux is the one lagging
> here.
> 
Heh, I saw "amiga" and stopped reading.  So it seems Linux on x86 is
the main laggard here...  I know PPC has had interesting debug features
for awhile now, and most arches have had kgdb for a long time.  Anyway,
there's plenty of work to do in this area to give Linux a decent system
level debugger...

--
Jesse Barnes, Intel Open Source Technology Center
