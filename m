Return-Path: <linux-kernel-owner+w=401wt.eu-S1751259AbXCECHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbXCECHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbXCECHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:07:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52914
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbXCECH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:07:28 -0500
Date: Sun, 04 Mar 2007 18:07:25 -0800 (PST)
Message-Id: <20070304.180725.126592830.davem@davemloft.net>
To: bunk@stusta.de
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, vonbrand@inf.utfsm.cl,
       davem@sunset.davemloft.net, sparclinux@vger.kernel.org, pavel@ucw.cz,
       oneukum@suse.de, gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       craig@codefountain.com, rol@as2917.net, rjw@sisk.pl,
       david-b@pacbell.net, a.zummo@towertech.it, rtc-linux@googlegroups.com
Subject: Re: [6/6] 2.6.21-rc2: known regressions
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070305015045.GK3441@stusta.de>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	<20070305015045.GK3441@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Mon, 5 Mar 2007 02:50:45 +0100

> Subject    : sparc64 compile error due to GENERIC_ISA_DMA removal
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8097
> Submitter  : Horst H. von Brand <vonbrand@inf.utfsm.cl>
> Caused-By  : David S. Miller <davem@sunset.davemloft.net>
>              commit 1b51d3a08b6c80a1e47d4c579c41abbe56cd3c44
> Status     : unknown

Fixed in current GIT.

commit 74bd7d093b8e87f35eaf3b14459b96a0e20d1d10
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Wed Feb 28 13:09:34 2007 -0800

    [SPARC64]: Fix parport_pc build.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

