Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbXL3SUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbXL3SUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 13:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXL3SUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 13:20:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44607 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbXL3SUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 13:20:03 -0500
Date: Sun, 30 Dec 2007 19:21:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       hpa@zytor.com, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230182138.GA2061@one.firstfloor.org>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230124852.GA30836@one.firstfloor.org> <20071230130544.GB16946@elte.hu> <20071230160817.GB32752@one.firstfloor.org> <20071230162853.GA32453@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230162853.GA32453@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> do you remember which old systems/chipsets were affected by this 
> problem? We had many - meanwhile fixed - PIC related problems, maybe 
> it's a red herring and the delay just papered it over.

Some old VIA chipsets at least iirc. Might be more.

-Andi
