Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYLVXa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYLVXa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbYLVXaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:30:12 -0500
Received: from www.tglx.de ([62.245.132.106]:50014 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbYLVXaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:30:10 -0500
Date: Tue, 23 Dec 2008 00:30:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrey Borzenkov <arvidjaar@mail.ru>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.28-rc9 regression: system fails to suspend
In-Reply-To: <200812220904.28780.arvidjaar@mail.ru>
Message-ID: <alpine.LFD.2.00.0812230029240.3723@localhost.localdomain>
References: <200812220904.28780.arvidjaar@mail.ru>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008, Andrey Borzenkov wrote:

> I will bisect as time permits, but may be it rings the bell for someone. 
> 2.6.28-rc7 is OK; rc9 switches console off and never goes in suspend. 
> Power remains on, keyboard is non-functional and the only way out is 
> power button. I have not tried rc8.
> 
> If somebody has soggestions what to (try to) revert, it would be great 
> and save quite a bit of time for bisecting.

Can you please provide detailed information about the machine which
exposes this problem ?

Thanks,

	tglx

