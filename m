Return-Path: <linux-kernel-owner+w=401wt.eu-S965654AbXG2Wxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965654AbXG2Wxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 18:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964974AbXG2Wxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 18:53:33 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:54041 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965006AbXG2Wxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 18:53:32 -0400
Date: Mon, 30 Jul 2007 07:52:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Richard Curnow <rc@rc0.org.uk>, linuxsh-shmedia-dev@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sh64: arch/sh64/kernel/signal.h - duplicate include removal
Message-ID: <20070729225251.GB8039@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jesper Juhl <jesper.juhl@gmail.com>, Richard Curnow <rc@rc0.org.uk>,
	linuxsh-shmedia-dev@lists.sourceforge.net,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <200707300044.00606.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707300044.00606.jesper.juhl@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 12:44:00AM +0200, Jesper Juhl wrote:
> This patch removes the duplicate inclusion of linux/personality.h 
> from arch/sh64/kernel/signal.c
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: Paul Mundt <lethal@linux-sh.org>
