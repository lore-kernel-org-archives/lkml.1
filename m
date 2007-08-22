Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbXHVKOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbXHVKOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbXHVKOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:14:43 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:49093 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbXHVKOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:14:42 -0400
X-Greylist: delayed 1484 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 06:14:42 EDT
Date: Wed, 22 Aug 2007 11:49:55 +0200
From: Jan Kasprzak <kas@fi.muni.cz>
To: Tony Jones <tonyj@suse.de>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: [patch 05/14] Convert from class_device to device for cosa sync driver
Message-ID: <20070822094955.GH8336@fi.muni.cz>
References: <20070820224806.154198000@suse.de> <20070820225105.840344000@suse.de> <20070821145958.GD26519@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821145958.GD26519@suse.de>
User-Agent: Mutt/1.4.1i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Envelope-To: kay.sievers@vrfy.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 22 Aug 2007 11:49:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Jones wrote:
: On Mon, Aug 20, 2007 at 03:48:11PM -0700, tonyj@suse.de wrote:
: > -- 
: > Content-Disposition: inline; filename=wan.patch
: > 
: > Convert from class_device to device for drivers/net/wan/cosa.  This is part of 
: > the work to eliminate struct class_device.
: 
: Signed-off-by: Tony Jones <tonyj@suse.de>

Acked-By: Jan "Yenya" Kasprzak <kas@fi.muni.cz>

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
========== Pruning mailbox after being ~10 days offline.
========== Sorry for the possibly delayed reply.
