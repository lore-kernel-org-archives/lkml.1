Return-Path: <linux-kernel-owner+w=401wt.eu-S934035AbXJLWmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbXJLWmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932632AbXJLWUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:20:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42194
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932618AbXJLWUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:20:50 -0400
Date: Fri, 12 Oct 2007 15:20:50 -0700 (PDT)
Message-Id: <20071012.152050.71091255.davem@davemloft.net>
To: gregkh@suse.de
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [GIT PATCH] USB patches for 2.6.23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071012221245.GA4559@kroah.com>
References: <20071012221245.GA4559@kroah.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Fri, 12 Oct 2007 15:12:45 -0700

> Alan Stern (44):
 ...
>       USB: mutual exclusion for EHCI init and port resets

Greg, if you haven't already, please consider queueing
this one up for -stable too.

Thanks!
