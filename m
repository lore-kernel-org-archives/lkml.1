Return-Path: <linux-kernel-owner+w=401wt.eu-S934308AbXEMQAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308AbXEMQAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757745AbXEMQAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:00:31 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:33871 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbXEMQA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:00:29 -0400
Message-ID: <464735F8.7040305@drzeus.cx>
Date: Sun, 13 May 2007 17:59:52 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Nicolas Pitre <nico@cam.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix PXA27x MMC workaround for bad CRC with 136 bit response
References: <46375B18.4080802@drzeus.cx> <20070509185636.GB26981@flint.arm.linux.org.uk> <46421BB5.7040504@drzeus.cx> <20070509221253.GC26981@flint.arm.linux.org.uk> <4642B122.5070609@drzeus.cx> <46432502.4050901@drzeus.cx> <alpine.LFD.0.99.0705101037220.24220@xanadu.home> <alpine.LFD.0.99.0705121122440.24220@xanadu.home> <4645E76B.2060704@drzeus.cx> <alpine.LFD.0.99.0705122307000.24220@xanadu.home>
In-Reply-To: <alpine.LFD.0.99.0705122307000.24220@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre wrote:
> ... and make it depend on the response flag instead of the command type.
>
> Signed-off-by: Nicolas Pitre <npitre@mvista.com>
> ---
>   

Fantastic. Applied.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

