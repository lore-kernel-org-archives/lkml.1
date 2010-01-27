Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468Ab0A0XRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab0A0XRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381Ab0A0XRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:17:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57598 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756051Ab0A0XRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:17:48 -0500
Date: Wed, 27 Jan 2010 23:19:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.33-rc5
Message-ID: <20100127231919.244f8873@lxorguk.ukuu.org.uk>
In-Reply-To: <1264633756.3075.116.camel@mulgrave.site>
References: <1264614691.3075.19.camel@mulgrave.site>
	<20100127222404.6dfdd0a7@lxorguk.ukuu.org.uk>
	<1264631609.3075.94.camel@mulgrave.site>
	<20100127224654.76db3693@lxorguk.ukuu.org.uk>
	<1264633756.3075.116.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This value can already be altered on the fly using the
> 
> /sys/block/<dev>/queue/max_sectors_kb
> 
> Setting that should work for the two reporters without impacting anyone
> else.

Ok I'll close it WONTFIX
