Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927Ab0ASV00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0ASV00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909Ab0ASV0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:26:24 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38277 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755908Ab0ASV0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:26:23 -0500
Date: Tue, 19 Jan 2010 21:27:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Florian Fainelli <florian@openwrt.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Joe Perches <joe@perches.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-omap@vger.kernel.org
Subject: Re: [RFC] [PATCH] watchdog_info separation and constify
Message-ID: <20100119212755.72e81d24@lxorguk.ukuu.org.uk>
In-Reply-To: <20100119211759.GE3804@infomag.iguana.be>
References: <20100119211759.GE3804@infomag.iguana.be>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010 22:17:59 +0100
Wim Van Sebroeck <wim@iguana.be> wrote:

> Hi All,
> 
> please comment on following patch.

Why move them out - why not just make them const ?
