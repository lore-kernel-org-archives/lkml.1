Return-Path: <linux-kernel-owner+w=401wt.eu-S964786AbXBTGhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786AbXBTGhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 01:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964789AbXBTGhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 01:37:12 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:38385 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964786AbXBTGhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 01:37:05 -0500
Message-ID: <45DA9719.8050001@drzeus.cx>
Date: Tue, 20 Feb 2007 07:37:13 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Petr Vandrovec <petr@vandrovec.name>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NCPFS and brittle connections
References: <459D1794.2060009@drzeus.cx> <459D38DA.4030803@vc.cvut.cz> <459D55E3.4000905@drzeus.cx> <459E01B2.50309@vc.cvut.cz> <45B77AE4.2010605@drzeus.cx> <45B79C35.2090302@vc.cvut.cz> <45B7D750.1040501@drzeus.cx> <45B868D5.9070409@vc.cvut.cz> <45B8845E.8070008@drzeus.cx> <45C57695.7000707@vc.cvut.cz> <45C61540.7000008@drzeus.cx> <45C6A99C.5030607@vc.cvut.cz> <45D97DF0.9070306@drzeus.cx> <45DA6150.7060704@vandrovec.name>
In-Reply-To: <45DA6150.7060704@vandrovec.name>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Vandrovec wrote:
>
> Hello,
>   it would be nice if these two copies (request->txbuf, and
> rxbuf->reply) could be eliminated, but I see no easy way how to do
> that...
>

At least we have the basic functionality now. One can start looking at
optimising it after that.

>
> Acked-by: Petr Vandrovec <petr@vandrovec.name>

I'll send it on to Linus then.

>
> Looks like a typo?  requres => request ?
>

Ooops. I'll fix that. :)

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

