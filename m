Return-Path: <linux-kernel-owner+w=401wt.eu-S934222AbXEMOiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222AbXEMOiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 10:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbXEMOiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 10:38:00 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:63854 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752490AbXEMOh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 10:37:59 -0400
Date: Sun, 13 May 2007 16:37:53 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
Message-ID: <20070513163753.210c3b89@dhcp-252-105.norway.atmel.com>
In-Reply-To: <46471FB7.5020308@drzeus.cx>
References: <117879333788-git-send-email-hskinnemoen@atmel.com>
	<46430A49.9090803@drzeus.cx>
	<20070510143737.54969394@dhcp-252-105.norway.atmel.com>
	<46432212.9070008@drzeus.cx>
	<20070510163348.0a117d92@dhcp-252-105.norway.atmel.com>
	<46434123.8040801@drzeus.cx>
	<20070510182749.219351cb@dhcp-252-105.norway.atmel.com>
	<46437562.9050501@drzeus.cx>
	<20070511103905.08530507@dhcp-252-105.norway.atmel.com>
	<464713FB.2060801@drzeus.cx>
	<20070513154722.6399074c@dhcp-252-105.norway.atmel.com>
	<46471FB7.5020308@drzeus.cx>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 16:24:55 +0200
Pierre Ossman <drzeus@drzeus.cx> wrote:

> Haavard Skinnemoen wrote:
> > On Sun, 13 May 2007 15:34:51 +0200
> > Pierre Ossman <drzeus@drzeus.cx> wrote:
> > 
> >> Does that sound like something that would work for you? From my point of view
> >> it's a much cleaner solution that has the benefit of not being tied into a
> >> certain subsystem (i.e. this would "fix" usb aswell).
> > 
> > Yes, that would definitely work.
> > 
> 
> I'll commence the kernel whipping. Will you be available for testing once I have
> something working?

Sure. I'll see if I can find a few more testers over at the avrfreaks
forums as well.

Haavard
