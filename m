Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbYIGKq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbYIGKq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 06:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYIGKqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 06:46:18 -0400
Received: from server.drzeus.cx ([85.8.24.28]:45023 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752757AbYIGKqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 06:46:17 -0400
Date: Sun, 7 Sep 2008 12:46:14 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, michael@free-electrons.com,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 1/1] [mmc] Fix comment in include/linux/mmc/host.h
Message-ID: <20080907124614.7c8a3821@mjolnir.drzeus.cx>
In-Reply-To: <1220343253-18681-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1220343253-18681-1-git-send-email-thomas.petazzoni@free-electrons.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Sep 2008 10:14:13 +0200
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> In include/linux/mmc/host.h, it is mentionned that the callback to
> know if a card is present or not is get_ro(). But it's get_cd().
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> ---

Applied, thanks.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
