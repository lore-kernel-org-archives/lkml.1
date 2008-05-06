Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbYEFIAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbYEFIAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYEFIAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:00:32 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:34045 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbYEFIAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:00:32 -0400
Date: Tue, 6 May 2008 09:58:35 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] avr32: export copy_page
Message-ID: <20080506095835.0e8385d8@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <20080505182957.GC17139@cs181133002.pp.htv.fi>
References: <20080505182957.GC17139@cs181133002.pp.htv.fi>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 May 2008 07:58:36.0465 (UTC) FILETIME=[FCDC1210:01C8AF4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:
> This patch fixes the following build error:
> 
> <--  snip  -->
> 
> ...
>   MODPOST 61 modules
> ERROR: "copy_page" [fs/fuse/fuse.ko] undefined!
> ...
> make[2]: *** [__modpost] Error 1
> 
> <--  snip  -->
> 
> Also add an empty line since *_page aren't "String functions".
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied. Thanks a lot, Adrian!

Haavard
