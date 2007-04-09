Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbXDINZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbXDINZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 09:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbXDINZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 09:25:49 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:47786 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbXDINZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 09:25:48 -0400
Message-ID: <461A3F72.7030205@drzeus.cx>
Date: Mon, 09 Apr 2007 15:28:18 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mockern@yandex.ru, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem: System hangs when I insert SD card
References: <46137794.000003.25729@ariel.yandex.ru>
In-Reply-To: <46137794.000003.25729@ariel.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern wrote:
> Hi,
> 
> I have a problem with SC card. System hangs when I insert SD card. But I have no any problems with MMC card. 
> 

Bug reports should include the driver maintainer in the list of recipients.
Which SD/MMC controller do you have?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
