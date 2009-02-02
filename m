Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbZBBUJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbZBBUJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZBBUJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:09:10 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:53983 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbZBBUJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:09:09 -0500
Date: Mon, 2 Feb 2009 21:09:04 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: gregkh <gregkh@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mmc: struct device - replace bus_id with dev_name(),
 dev_set_name()
Message-ID: <20090202210904.1bf535db@mjolnir.drzeus.cx>
In-Reply-To: <1232923842.2924.14.camel@nga>
References: <1232923842.2924.14.camel@nga>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2009 23:50:42 +0100
Kay Sievers <kay.sievers@vrfy.org> wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: mmc: struct device - replace bus_id with dev_name(), dev_set_name()
> 
> Cc: drzeus-mmc@drzeus.cx
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---

Applied, thanks.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
