Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022Ab0AZAH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab0AZAH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698Ab0AZAHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:07:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697Ab0AZAHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:07:52 -0500
Date: Mon, 25 Jan 2010 16:07:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-mmc@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Cliff Cai <cliff.cai@analog.com>
Subject: Re: [PATCH 3/3] mmc: bfin_sdh: set timeout based on actual card
 data
Message-Id: <20100125160733.d7930d71.akpm@linux-foundation.org>
In-Reply-To: <1263888131-25656-3-git-send-email-vapier@gentoo.org>
References: <1263888131-25656-1-git-send-email-vapier@gentoo.org>
	<1263888131-25656-3-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010 03:02:11 -0500
Mike Frysinger <vapier@gentoo.org> wrote:

> From: Cliff Cai <cliff.cai@analog.com>
> 
> The hardcoded value doesn't really work for all cards.
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Please don't write crappy changelogs.  

How am I to determine whether we want this fix in 2.6.33 and possibly
earlier?  How is anyone whose 2.6.32.x kernel "doesn't really work" to
determine whether this patch might fix it?

