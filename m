Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab0CLUAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 15:00:52 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39431 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758432Ab0CLUAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 15:00:49 -0500
Date: Fri, 12 Mar 2010 14:52:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Florian Mickler <florian@mickler.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/2]  rfkill sysfs ABI
Message-ID: <20100312195257.GB17689@tuxdriver.com>
References: <1268416988-24862-1-git-send-email-florian@mickler.org> <20100312191819.73ac4700@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312191819.73ac4700@schatten.dmk.lab>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 07:18:19PM +0100, Florian Mickler wrote:

> sorry! I just realised that you already have the blocked_sw / blocked_hw one's
> queued. 
> 
> This just changes the name of blocked_sw and blocked_hw to "soft" and
> "hard". 
> 
> I don't know what you wanna do. I'm fine with blocked_hw and
> blocked_sw as it's referenced as such (hw/sw) in the code, but Marcel
> wanted to get away from the "hard blocked by hardware" notation, as it
> suggests that the transmitter could only be blocked by hardware...

Could you just submit a third patch that makes the requested name changes?

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
