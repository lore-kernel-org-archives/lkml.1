Return-Path: <linux-kernel-owner+w=401wt.eu-S1751756AbXA0NBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbXA0NBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 08:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbXA0NBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 08:01:20 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41164 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbXA0NBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 08:01:20 -0500
Message-ID: <45BB4D20.9080607@drzeus.cx>
Date: Sat, 27 Jan 2007 14:01:20 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: au1xmmc: return errors for unknown response types
References: <20070125092741.GA8512@roarinelk.homelinux.net>
In-Reply-To: <20070125092741.GA8512@roarinelk.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Lauss wrote:
> au1xmmc: return error when encountering unhandled/unknown response type.
> 
> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
> 

Thanks, applied.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
