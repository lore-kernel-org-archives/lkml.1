Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbXD1Jq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbXD1Jq2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 05:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbXD1Jq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 05:46:28 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:37412 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbXD1Jq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 05:46:27 -0400
Message-ID: <4633183A.9050706@drzeus.cx>
Date: Sat, 28 Apr 2007 11:47:38 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
To: nucleodyne@comcast.net
CC: linux-kernel@vger.kernel.org
Subject: Re: Winbond SD/MMC controller
References: <042620070647.21264.46304AE50000DBB80000531022007510900A02970B010A040C9A02@comcast.net>
In-Reply-To: <042620070647.21264.46304AE50000DBB80000531022007510900A02970B010A040C9A02@comcast.net>
X-Mime-Autoconverted: from 8bit to 7bit by courier 0.53
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nucleodyne@comcast.net wrote:
> Is there a linux driver for Winbond W86L388D SD/MMC controller?
> 

Not that I've seen, no.

> The data sheet is available at:
> http://www.winbond-usa.com/products/winbond_products/pdfs/PCIC/W86L388D_20051117.pdf

I'm afraid that's just a summary. As you can see, there is no listing of the
meaning of those registers.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
