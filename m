Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbXCPIim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbXCPIim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXCPIil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:38:41 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:59966 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbXCPIil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:38:41 -0400
Message-ID: <45FA57AF.9080100@drzeus.cx>
Date: Fri, 16 Mar 2007 09:39:11 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Pavel Pisa <ppisa4lists@pikron.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: i.MX/MX1 SDHC fix/workaround of SD card recognition problems
References: <200703080000.41101.ppisa@pikron.com> <45F49297.9090309@drzeus.cx> <200703120333.27581.ppisa4lists@pikron.com>
In-Reply-To: <200703120333.27581.ppisa4lists@pikron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Pisa wrote:
> this should go to 2.6.21, I have hold this for some
> months and I have discussed it in the thread
> "Re: CRC Errors with SD cards in 4bits mode (on i.MXl)"
> You have been CCed. This is not solution for seen data CRC
> problem, but solves problems with recognition of cards
> which has been timing sensitive sometimes.
>   

I'll push it to Linus and see if he swallows ;)

> I have sent it into Russell's patch queue with my others
> MX1 fixes I have intended to be included in 2.6.21.
> It was probably mistake for this one, because it should
> go through your tree. If you send it to mainline
> yourself, I would discard patch from patch daemon.
>
>   

For Russell's sake, things should probably go through my tree. Otherwise
he'll have to deal with all sorts of merge problems because of the
things I do.

> We have spoken about MX1 SDHC maintainership.
> I am attaching my subscription.
> I am not sure about mailing list field there.
> Do you suggest this one, ALKML or other?
>
>   

sdhci is outright wrong. That list is only for the sdhci driver. I
suggest LAK or LKML, preferably the one with the most MX1 users and/or
developers.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

