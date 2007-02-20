Return-Path: <linux-kernel-owner+w=401wt.eu-S1030468AbXBTVvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030468AbXBTVvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030471AbXBTVvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:51:24 -0500
Received: from www.osadl.org ([213.239.205.134]:41497 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030470AbXBTVvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:51:23 -0500
Subject: Re: 2.6.20-git15 BUG: soft lockup detected on CPU#0! - timers?
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com>
References: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 22:56:24 +0100
Message-Id: <1172008584.25076.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 19:54 +0100, Michal Piotrowski wrote:
>
> Might it be 6ba9b346e1e0eca65ec589d32de3a9fe32dc5de6 commit?

I doubt that it is, but can you revert it ?

	tglx


