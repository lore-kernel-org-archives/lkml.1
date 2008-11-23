Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbYKWNNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbYKWNNx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 08:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbYKWNNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 08:13:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:43880 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725AbYKWNNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 08:13:44 -0500
Date: Sun, 23 Nov 2008 14:13:43 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space as
 executable
Message-ID: <20081123141343.12b3b69a@kopernikus.site>
In-Reply-To: <20081120202451.GH30873@infomag.infomag.iguana.be>
References: <1226674023-5374-1-git-send-email-bwalle@suse.de>
	<20081118143015.72af31d3.akpm@linux-foundation.org>
	<20081118233229.294270fb@kopernikus.site>
	<183C1D5A376DE343AA8F94FC2A1EC1493AA5CEE7AB@GVW1091EXB.americas.hpqcorp.net>
	<20081119093041.1af8fd7e.akpm@linux-foundation.org>
	<20081119183444.56b342cb@hale.suse.de>
	<20081119230014.GC30873@infomag.infomag.iguana.be>
	<20081120000215.45071a50@kopernikus.site>
	<20081119231124.GD30873@infomag.infomag.iguana.be>
	<183C1D5A376DE343AA8F94FC2A1EC1493AA5D6987F@GVW1091EXB.americas.hpqcorp.net>
	<20081120202451.GH30873@infomag.infomag.iguana.be>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wim Van Sebroeck [2008-11-20 21:24]:
> 
> > I tested changing the return value to NOTIFY_OK always.
> 
> Splendid. I changed the patch (see below).
> Can you check if all is ok now, so that I can sent them off for mainline inclusion?

Sorry for my late reply, I'm really busy these days. :-(

In that case we don't need to change the allow_kdump variable. I send a
patch with corrected patch description just afterwards.



Regards,
Bernhard

