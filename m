Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbYGDNpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbYGDNpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYGDNph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:45:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58034 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbYGDNpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:45:36 -0400
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Takashi Iwai <tiwai@suse.de>, Hugh Dickins <hugh@veritas.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
In-Reply-To: <486E28BB.1030205@garzik.org>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
	 <20080703205548.D6E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <486CC440.9030909@garzik.org>
	 <Pine.LNX.4.64.0807031353030.11033@blonde.site>
	 <s5hmykxc3ja.wl%tiwai@suse.de>
	 <1215177471.10393.753.camel@pmac.infradead.org>
	 <s5hej69lqzk.wl%tiwai@suse.de>  <486E28BB.1030205@garzik.org>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 14:45:26 +0100
Message-Id: <1215179126.10393.771.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-04 at 09:42 -0400, Jeff Garzik wrote:
> mkinitrd and similar scripts must be updated, so that drivers that 
> worked prior to dwmw2's changes will continue to work after dwmw2's
> changes.

> If you fail to update some script somewhere, then the driver will be 
> copied into the initramfs, but not the firmware, with obvious results.

No, mkinitrd works fine, because a whole boatload of drivers _already_
require it to work that way and have done for a long time.

Either you are severely mistaken, or you are being deliberately
misleading.

-- 
dwmw2

