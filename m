Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbXBTNG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbXBTNG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbXBTNG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:06:27 -0500
Received: from smtp.nokia.com ([131.228.20.173]:61630 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbXBTNG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:06:27 -0500
Subject: Re: [PATCH 07/44 take 2] [UBI] misc unit header
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070219110017.GC16930@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165459.5845.18967.sendpatchset@localhost.localdomain>
	 <20070217225908.GC16522@thunk.org>  <20070219110017.GC16930@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Feb 2007 14:56:17 +0200
Message-Id: <1171976177.4039.15.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Feb 2007 12:56:17.0512 (UTC) FILETIME=[82B3CE80:01C754EE]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070220145259-3681FBB0-0274D2C5/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 11:00 +0000, Christoph Hellwig wrote:
> > It's not clear the assertion is all that useful, but if you must have
> > it, why not do the check as an inline (with the assertion normally
> > turned off), and then call out to kmemdup()?
> 
> Agreement to all of the above.  And _please_ move all kdoc comments to
> the implementation files.

Will be done.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

