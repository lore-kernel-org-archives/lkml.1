Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbZCXUKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbZCXUKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759680AbZCXUKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:10:42 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:57158 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759648AbZCXUKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:10:41 -0400
Date: Tue, 24 Mar 2009 21:10:37 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: "Lavinen Jarkko (Nokia-M/Helsinki)" <jarkko.lavinen@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: MMC: Accept EXT_CSD rev 1.3 assuming it is backwards compatible
 with 1.2
Message-ID: <20090324211037.65cd05ea@mjolnir.ossman.eu>
In-Reply-To: <49C8CE1B.7000802@nokia.com>
References: <49C8CE1B.7000802@nokia.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 14:12:11 +0200
Adrian Hunter <adrian.hunter@nokia.com> wrote:

> From a939998e34cbc263317d51b21ab52c8d5863a913 Mon Sep 17 00:00:00 2001
> From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
> Date: Thu, 27 Nov 2008 14:30:32 +0200
> Subject: MMC: Accept EXT_CSD rev 1.3 assuming it is backwards compatible with 1.2
> 
> Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
> ---

I don't like the whole "assuming" part. Do the specs back this up?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
