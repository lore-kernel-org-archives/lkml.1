Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYGGUOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYGGUOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 16:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbYGGUOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 16:14:24 -0400
Received: from server.drzeus.cx ([85.8.24.28]:45311 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755304AbYGGUOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 16:14:23 -0400
Date: Mon, 7 Jul 2008 22:14:18 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: mmc vs. suspend: WARNING: drivers/base/power/main.c:77
 device_pm_add
Message-ID: <20080707221418.4b9aa264@mjolnir.drzeus.cx>
In-Reply-To: <20080707185529.GA1687@elf.ucw.cz>
References: <20080707185529.GA1687@elf.ucw.cz>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008 20:55:29 +0200
Pavel Machek <pavel@suse.cz> wrote:

> Hi!
> 
> 
> I got this while suspending with mmc card inserted. 2.6.26-rc8.
> 

Bug 10984:

http://bugzilla.kernel.org/show_bug.cgi?id=10984

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
