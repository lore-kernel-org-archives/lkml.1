Return-Path: <linux-kernel-owner+w=401wt.eu-S1762328AbXGJHMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762328AbXGJHMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbXGJHMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:12:08 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:42439 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbXGJHMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:12:07 -0400
Date: Tue, 10 Jul 2007 09:12:00 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Trilok Soni" <soni.trilok@gmail.com>
Cc: i2c@lm-sensors.org, "Jean Delvare" <khali@linux-fr.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Tony Lindgren" <tony@atomide.com>,
       "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       amit.kucheria@gmail.com
Subject: Re: OMAP: Add TI TWL92330/Menelaus Power Management chip driver
Message-ID: <20070710091200.60d1950f@poseidon.drzeus.cx>
In-Reply-To: <5d5443650707092353v153fe90clbd1a42d465ed79a4@mail.gmail.com>
References: <5d5443650707092353v153fe90clbd1a42d465ed79a4@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 12:23:06 +0530
"Trilok Soni" <soni.trilok@gmail.com> wrote:

> 
> RTC part was reviewed and acked-by RTC maintainer. CCing to lkml and
> MMC maintainer this time.
> 

There's nothing that really touches any mmc code in there. So I have no
comments about it.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
