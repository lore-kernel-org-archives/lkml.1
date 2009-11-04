Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZKDQbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZKDQbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757041AbZKDQbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:31:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47286
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756505AbZKDQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:31:50 -0500
Date: Wed, 04 Nov 2009 08:32:15 -0800 (PST)
Message-Id: <20091104.083215.148844966.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: johannes@sipsolutions.net, marcel@holtmann.org, dmitry.torokhov@gmail.com,
       torvalds@linux-foundation.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091104072315.18f56322.akpm@linux-foundation.org>
References: <20091103223433.23765578.akpm@linux-foundation.org>
	<20091104.004157.86565200.davem@davemloft.net>
	<20091104072315.18f56322.akpm@linux-foundation.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 4 Nov 2009 07:23:15 -0800

> Although if you can help these:
> 
> isdn-hisax-fix-lock-imbalance.patch
> misdn-fix-reversed-if-in-st_own_ctrl.patch
> isdn-eicon-use-offsetof.patch
> hisax-fix-test-in-waitforxfw.patch
> hfc_usb-fix-read-buffer-overflow.patch

Applied to net-2.6

> isdn-eicon-return-on-error.patch

Also applied to net-2.6, holy crap someone run that driver through
some auto-formatting tool! :-)

