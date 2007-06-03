Return-Path: <linux-kernel-owner+w=401wt.eu-S1761452AbXFCMCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452AbXFCMCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 08:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbXFCMCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 08:02:44 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:43626 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757979AbXFCMCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 08:02:44 -0400
Message-ID: <4662AE11.70107@drzeus.cx>
Date: Sun, 03 Jun 2007 14:03:29 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: mmc0: unrecognised SCR structure version 1
References: <20070530165705.GD29337@enneenne.com>
In-Reply-To: <20070530165705.GD29337@enneenne.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti wrote:
> Hello,
> 
> using MMC/SD support on my PXA270 based board I get this error:
> 
>    mmc0: unrecognised SCR structure version 1
> 
> when I insert a MINISD card.
> 
> I tried to find on the net some specifications for the SCR structure
> version 1 but I found nothing useful... someone has a similar problem
> or can suggest to me where I can find such specifications?
> 

To my knowledge, no such version exists. So either your card is broken or you
have some transfer problem on your board. What's the name of this card and have
you tried any others?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
