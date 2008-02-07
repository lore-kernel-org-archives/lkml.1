Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbYBGHdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbYBGHdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbYBGHdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:33:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56637
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754539AbYBGHdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:33:09 -0500
Date: Wed, 06 Feb 2008 23:33:39 -0800 (PST)
Message-Id: <20080206.233339.74740365.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080207071807.GA13866@suse.de>
References: <20080207070044.GA4851@suse.de>
	<20080206.231144.174648341.davem@davemloft.net>
	<20080207071807.GA13866@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Wed, 6 Feb 2008 23:18:07 -0800

> How about this attempt?

That works, thanks.  Please push to Linus :-)

Acked-by: David S. Miller <davem@davemloft.net>
