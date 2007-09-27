Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbXI0UlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbXI0UlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 16:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbXI0UlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 16:41:12 -0400
Received: from www.osadl.org ([213.239.205.134]:53125 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753040AbXI0UlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 16:41:12 -0400
Subject: Re: NO_HZ hangs up AMD MK-36
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Tyschenko <dtyschenko@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a6a840cd0709271328p76ee6a22tf3b60678d6a2d455@mail.gmail.com>
References: <a6a840cd0709271328p76ee6a22tf3b60678d6a2d455@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 22:41:09 +0200
Message-Id: <1190925669.23376.145.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-27 at 23:28 +0300, Dmitry Tyschenko wrote:
> I have laptop Asus X50M. Using old Debian Etch from February.
> Kernel from 2.6.21 doesn't boot, hangs up just in 10seconds -  1minute
> after GRUB screen.
> I have tryed different versions of gcc (4.1.1, 4.1.2, 4.2.1) to build
> 2.6.22.8 kernel, but no results.
> But if I disable NO_HZ option 2.6.21 is working fine for me.

We have fixed a bunch of bugs in this area. Can you please try the
latest mainline kernel, whether the problem still persists ?

Thanks,

	tglx


