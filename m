Return-Path: <linux-kernel-owner+w=401wt.eu-S1945939AbXD3QFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945939AbXD3QFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423770AbXD3QFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:05:38 -0400
Received: from www.osadl.org ([213.239.205.134]:37331 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1945908AbXD3QFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:05:30 -0400
Subject: Re: [patch 3/9] AVR32: Spinlock initializer cleanup
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <20070430173003.4b848b79@dhcp-252-105.norway.atmel.com>
References: <20070429154221.159165000@linutronix.de>
	 <20070429154337.455859000@linutronix.de>
	 <20070430173003.4b848b79@dhcp-252-105.norway.atmel.com>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 18:07:40 +0200
Message-Id: <1177949261.5791.229.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 17:30 +0200, Haavard Skinnemoen wrote:
> On Sun, 29 Apr 2007 16:10:34 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Applied to my avr32-arch branch. Thanks.
> 
> Where did the rest of the series go, btw? I didn't see any patches on
> LKML...

My script did something wrong and vger ate it. Not sure what happened,
it's the same script I use since years. Will resend tomorrow, when I
know what the breakage is.

	tglx


