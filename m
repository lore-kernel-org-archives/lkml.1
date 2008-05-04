Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbYEDKlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbYEDKlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 06:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbYEDKlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 06:41:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36275 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114AbYEDKlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 06:41:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: Suspend to memory is freezing my machine
Date: Sun, 4 May 2008 12:40:52 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com>
In-Reply-To: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805041240.52988.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 4 of May 2008, Zdenek Kabelac wrote:
> Hello

Hi,

> With recent 2.6.25 & 2.6.26-rc1 git (around 1 week) I get occasionally
> complete freeze of my T61 during suspend. (dual core, 2GB).

How reproducible is this?

> I'm running kernel with no_console_suspend - but all I can see is
> blinking cursor on an empty screen - thus even when I run kernel with
> most debug options turned on, I can't pass more details so far.  I run
> suspend with with SD card in - so maybe some update in the MMC driver
> might be responsible for this ?
> 
> Also - I think that option no_console_suspend doens't work correctly -
> as many times with suspend I do not see any log message on my console
> screen. However sometimes the log is shown.

It would be helpful if you could verify if:

(1) The problem occurs without no_console_suspend.
(2) The problem occurs without the SD card.

Thanks,
Rafael
