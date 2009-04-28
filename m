Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZD1Thl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZD1Thl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZD1Thc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:37:32 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:43777 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbZD1Thc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:37:32 -0400
Date: Tue, 28 Apr 2009 21:37:30 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Nicolas Pitre <nico@cam.org>
Cc: Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mvsdio: fix CONFIG_PM=y build
Message-ID: <20090428213730.070e6448@mjolnir.ossman.eu>
In-Reply-To: <alpine.LFD.2.00.0904201925580.6741@xanadu.home>
References: <20090420184454.GA8867@debian>
	<alpine.LFD.2.00.0904201925580.6741@xanadu.home>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 19:26:32 -0400 (EDT)
Nicolas Pitre <nico@cam.org> wrote:

> On Tue, 21 Apr 2009, Rabin Vincent wrote:
> 
> > Fix usage of obsolete parameters and functions in the driver's PM
> > callbacks.
> > 
> > Signed-off-by: Rabin Vincent <rabin@rab.in>  
> 
> Acked-by: Nicolas Pitre <nico@marvell.com>

Queued, thanks.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
