Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbYIOWjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbYIOWjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 18:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYIOWja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 18:39:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46246
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753394AbYIOWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 18:39:29 -0400
Date: Mon, 15 Sep 2008 15:39:23 -0700 (PDT)
Message-Id: <20080915.153923.47782615.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080915223407.GB15421@havoc.gtf.org>
References: <20080915212459.GE3994@havoc.gtf.org>
	<20080915.150746.24873255.davem@davemloft.net>
	<20080915223407.GB15421@havoc.gtf.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Mon, 15 Sep 2008 18:34:07 -0400

> So if a small, easily-mergable fix for a major bug like an oops
> appears on July 30, being strict to your plan has this fix waiting
> until almost 2009 (2.6.28 release), a wait of over five months.
> 
> That is not serving Linux users, our primary customers.

I personally partly agree with you, but Linus put his foot down and
I'm implementing the stated policy by doing the same.
