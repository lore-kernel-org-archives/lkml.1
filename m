Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbZFDWvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbZFDWvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 18:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZFDWvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 18:51:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbZFDWvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 18:51:17 -0400
Date: Fri, 5 Jun 2009 00:51:18 +0200 (CEST)
From: Jiri Kosina <trivial@kernel.org>
X-X-Sender: jkosina@wotan.suse.de
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH] Typo: ETIMEOUT -> ETIMEDOUT
In-Reply-To: <20090604162028.7919ff89@hyperion.delvare>
Message-ID: <alpine.LNX.2.00.0906050050140.7457@wotan.suse.de>
References: <20090604162028.7919ff89@hyperion.delvare>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Jean Delvare wrote:

> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  arch/arm/mach-sa1100/jornada720_ssp.c |    4 ++--
>  drivers/net/qlge/qlge_main.c          |    2 +-
>  drivers/net/usb/usbnet.c              |    2 +-
>  drivers/staging/wlan-ng/hfa384x_usb.c |    2 +-
>  kernel/rtmutex.c                      |    2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)

Applied, thanks a lot Jean.

-- 
Jiri Kosina
