Return-Path: <linux-kernel-owner+w=401wt.eu-S934803AbXFFSFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934803AbXFFSFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758476AbXFFSFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:05:25 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:45517 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbXFFSFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:05:25 -0400
Message-ID: <4666F7A1.6030202@drzeus.cx>
Date: Wed, 06 Jun 2007 20:06:25 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: mmc0: unrecognised SCR structure version 1
References: <20070530165705.GD29337@enneenne.com> <4662AE11.70107@drzeus.cx> <20070603145529.GC3879@enneenne.com>
In-Reply-To: <20070603145529.GC3879@enneenne.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti wrote:
> I suppose the same... but this is the only cards who gives me such
> problems! What do you think it could be the problem? Maybe some PXA
> MMC special settings?
>   

I'm afraid I have little experience with PXA. Perhaps you can find
someone on the linux arm kernel mailing list with more insight?

> The card is a 512MB MiniSD by Viking InterWorks.
>
>   

Sounds like a fairly common card. Cards so broken that they give an
incorrect scr version should be rare, so I would guess that there is
some transfer problem with the PXA. I don't suppose you have any other
linux based platforms to test the card in?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

