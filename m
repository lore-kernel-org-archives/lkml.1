Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbXJ0NBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbXJ0NBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 09:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbXJ0NAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 09:00:55 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:60237 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbXJ0NAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 09:00:54 -0400
Date: Sat, 27 Oct 2007 15:00:50 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, tonyj@suse.de,
       spi-devel-general@lists.sourceforge.net
Subject: Re: mmc_spi stopped working
Message-ID: <20071027150050.3697c1db@poseidon.drzeus.cx>
In-Reply-To: <200710241527.46458.david-b@pacbell.net>
References: <20071017211923.31fde15e@poseidon.drzeus.cx>
	<20071017193713.38D3923A5D5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20071017215217.177cdb14@poseidon.drzeus.cx>
	<200710241527.46458.david-b@pacbell.net>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 15:27:46 -0700
David Brownell <david-b@pacbell.net> wrote:

> 
> This is another case where whacking around in sysfs seems
> unavoidable, even when it breaks things.  The patch below
> works around that that change.  It seems like something that
> should go through you, not directly through Linus...
> 

Indeed. Applied.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
