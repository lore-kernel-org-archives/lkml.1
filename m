Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbXJLNxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbXJLNxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbXJLNxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:53:36 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:47042 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbXJLNxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:53:35 -0400
Date: Fri, 12 Oct 2007 15:53:20 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [GIT PULL] MMC updates
Message-ID: <20071012155320.47a2ea92@poseidon.drzeus.cx>
In-Reply-To: <3ae72650710120518p6132e459q7ee234d640ad0a1c@mail.gmail.com>
References: <20071010212149.0073ee08@poseidon.drzeus.cx>
	<alpine.LFD.0.999.0710112228200.6887@woody.linux-foundation.org>
	<20071012074556.574584db@poseidon.drzeus.cx>
	<3ae72650710120518p6132e459q7ee234d640ad0a1c@mail.gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 14:18:26 +0200
"Kay Sievers" <kay.sievers@vrfy.org> wrote:

> 
> I see the same here. MMC needs a dependency on LEDS_TRIGGERS, I guess.
> 

I'd rather not, and I thought I avoided it. I must have missed
ifdef:ing some references.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
