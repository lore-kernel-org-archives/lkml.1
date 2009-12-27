Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZL0OUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZL0OUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 09:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZL0OUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 09:20:24 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:42261 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZL0OUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 09:20:23 -0500
Date: Sun, 27 Dec 2009 15:20:21 +0100
From: Andreas Mohr <andi@lisas.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFT] Input: speed up suspend/shutdown for PS/2 mice and
	keyboards
Message-ID: <20091227142021.GA30090@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221070951.GA4170@core.coreip.homeip.net>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On an ATI SB600 (RS690), no problems either on mouse/kbd after a S2R cycle,
on current git with this patch applied (verified).
And this with a rather problematic "new-fangled, designer (tm)"
Logitech Wireless Keyboard M/N Y-RR54 , P/N 867512-0102 (plus mouse!),
plugged into PS/2 connectors!

Thanks for your work!

Andreas Mohr
