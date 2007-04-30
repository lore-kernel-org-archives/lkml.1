Return-Path: <linux-kernel-owner+w=401wt.eu-S1423365AbXD3Pam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423365AbXD3Pam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423373AbXD3Pam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:30:42 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:61595 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423365AbXD3Pab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:30:31 -0400
Date: Mon, 30 Apr 2007 17:30:03 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 3/9] AVR32: Spinlock initializer cleanup
Message-ID: <20070430173003.4b848b79@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070429154337.455859000@linutronix.de>
References: <20070429154221.159165000@linutronix.de>
	<20070429154337.455859000@linutronix.de>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 16:10:34 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Applied to my avr32-arch branch. Thanks.

Where did the rest of the series go, btw? I didn't see any patches on
LKML...

Haavard
