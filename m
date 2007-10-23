Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbXJWSYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbXJWSYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXJWSYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:24:05 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:59635 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbXJWSYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:24:04 -0400
Subject: Re: [BUG] rfcomm]
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Alon Bar-Lev <alon.barlev@gmail.com>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0710232004260.18815@twin.jikos.cz>
References: <200710231950.31313.alon.barlev@gmail.com>
	 <1193162106.6184.208.camel@violet>
	 <Pine.LNX.4.64.0710232004260.18815@twin.jikos.cz>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 20:25:05 +0200
Message-Id: <1193163905.6184.214.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > Second, can you try without uswsusp or suspend2. Both of them are not 
> > upstream and I can't tell how much these would effect this kind of 
> > behavior.
> 
> Hi Marcel,
> 
> actually uswsusp has been upstream for quite some time already. See 
> Documentation/power/userland-swsusp.txt

nice. I've never used it. Currently I am using what comes with Ubuntu
7.10 and that seems to work.

Regards

Marcel


