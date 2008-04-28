Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbYD1Lf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbYD1Lf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 07:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763049AbYD1Lfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 07:35:48 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:50590 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762540AbYD1Lfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 07:35:47 -0400
Date: Mon, 28 Apr 2008 13:35:23 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "Justin Mattock" <justinmattock@gmail.com>
Cc: "Jiri Slaby" <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: post-2.6.25 locks up hard without any message
Message-ID: <20080428133523.34197aa3@mjolnir.drzeus.cx>
In-Reply-To: <dd18b0c30804251650me69a06fi573418ed48a3261d@mail.gmail.com>
References: <20080425175423.4bfd1c7b@mjolnir.drzeus.cx>
	<48125094.9070007@gmail.com>
	<dd18b0c30804251650me69a06fi573418ed48a3261d@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008 23:50:17 +0000
"Justin Mattock" <justinmattock@gmail.com> wrote:

> 
> You might have what I was experiencing, a complete lock up, I received
> a patch from Peter Zijlstra that resolved the issue for me, I pass it
> to you:

Seems like your mailer screwed up all the whitespace in the patch.
Could you try resending it as an attachment?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
