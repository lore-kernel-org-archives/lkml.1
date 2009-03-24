Return-Path: <linux-kernel-owner+w=401wt.eu-S1763869AbZCXULm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763869AbZCXULm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759916AbZCXULa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:11:30 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:57158 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758945AbZCXUL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:11:28 -0400
Date: Tue, 24 Mar 2009 21:11:24 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Purushotam Kumar <purushotam@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org, purushotam@ti.com
Subject: Re: [PATCH 1/1] DaVinci: MMC: V3: MMC/SD controller driver for
 DaVinci family.
Message-ID: <20090324211124.3032038d@mjolnir.ossman.eu>
In-Reply-To: <1237898570-20313-1-git-send-email-purushotam@ti.com>
References: <1237898570-20313-1-git-send-email-purushotam@ti.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 18:12:50 +0530
Purushotam Kumar <purushotam@ti.com> wrote:

> From: Purshotam Kumar <purushotam@ti.com>
> 
> This patch adds support for MMC/SD controller driver for DaVinci family SoC.
> This patch will work for SoC like DM6446 and DM355. SoC like DM365 and
> DA830 also has same controller with small variations and could supported/added
> easily by using this version of patch. It means that this version of patch
> could be used for all SoC which has been derived from DaVinci family.
> 
> This patch has been generated against latest 2.6.29 mainline kernel. This patch
> will not compile currently because it depends notably on the EDMA utilities and
> chip/board setup, that will come at some point through the ARM tree. Please use
> currently DaVinci GIT tree for EDMA utilities and chip/board setup etc.
> 
> Many thanks to David Brownell (david-b@pacbell.net) for his all support.
> 
> Updated by adding quotes around "MMCSDCLK" in order fix build bug in this
> version of patch.
> 
> Signed-off-by: Purshotam Kumar <purushotam@ti.com>
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> ---

Kumar, please look at the comments I made to your earlier patch.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
