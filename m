Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbXIPQtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbXIPQtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 12:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXIPQt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 12:49:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49798
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbXIPQt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 12:49:28 -0400
Date: Sun, 16 Sep 2007 09:49:27 -0700 (PDT)
Message-Id: <20070916.094927.03980074.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: vonbrand@inf.utfsm.cl, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: SPARC{,64}: kernel_termios_to_user_termios_1 missing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070916004231.cf2df744.akpm@linux-foundation.org>
References: <200709152137.l8FLbtXP001446@laptop13.inf.utfsm.cl>
	<20070915.153602.74747413.davem@davemloft.net>
	<20070916004231.cf2df744.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 16 Sep 2007 00:42:31 -0700

> Hopefully bb8bd3a52a5dbca8bea31bfc72dacfb384170e69 (merged six hours ago)
> will have fixed this.  It Works For Me.

Yep, looks good here too.
