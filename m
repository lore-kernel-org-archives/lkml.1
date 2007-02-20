Return-Path: <linux-kernel-owner+w=401wt.eu-S932792AbXBTRmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792AbXBTRmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932953AbXBTRmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:42:51 -0500
Received: from smtp.nokia.com ([131.228.20.172]:42993 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792AbXBTRmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:42:50 -0500
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: John Stoffel <john@stoffel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <17883.2878.998312.904061@jfsnew.stoffel.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <17883.2878.998312.904061@jfsnew.stoffel.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Feb 2007 19:41:49 +0200
Message-Id: <1171993309.4039.54.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Feb 2007 17:41:49.0262 (UTC) FILETIME=[660566E0:01C75516]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070220193908-1DB25BB0-38819757/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John,

On Tue, 2007-02-20 at 09:52 -0500, John Stoffel wrote:
> Can you define UBI in each and every file you create?  This is a
> completely unique acronym and I'm sure a bunch of people will be going
> "wtf" when they read this, I know I was.

Do you mean adding something like "This is file is a part of the
Unsorted Block Images (UBI) subsystem" to the header of each file?

> Neat stuff!  Too bad you don't have a more descriptive name for it,
> UBI just doesn't seem to have any connection to LVM for Flash plus
> wear leveling.

Well, this name was born inside IBM, the guys in CC and may comment on
this. Feel free to advice a better name, although renaming this is
something I really do not want to do.

And it indeed has no connection to LVM, I just used the analogy to
quickly provide the idea what is this about.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

