Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbXBSNMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbXBSNMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbXBSNMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:12:55 -0500
Received: from smtp.nokia.com ([131.228.20.172]:41310 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbXBSNMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:12:54 -0500
Subject: Re: [PATCH 10/44 take 2] [UBI] debug unit implementation
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <200702172200.12910.arnd@arndb.de>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165514.5845.31845.sendpatchset@localhost.localdomain>
	 <200702172200.12910.arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Feb 2007 14:29:20 +0200
Message-Id: <1171888160.13817.18.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Feb 2007 12:29:20.0154 (UTC) FILETIME=[9444CFA0:01C75421]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070219142649-202B7BB0-18013630/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 22:00 +0100, Arnd Bergmann wrote:
> This whole file looks like it can be removed, as nothing in here
> is really relevant for regular operation. I'm sure that much of it
> was a good help in developing the code and finding the bugs in here,
> but why would you want to merge it into the mainline kernel?

UBI is a new thing and it will likely be tweaked, improved, etc. When I
have a bugreport, I just ask to enable debugging and provide me the log.
I is a great help.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

