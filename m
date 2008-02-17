Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYBQAzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYBQAzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 19:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYBQAzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 19:55:05 -0500
Received: from www.tglx.de ([62.245.132.106]:47983 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbYBQAzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 19:55:03 -0500
Date: Sun, 17 Feb 2008 01:54:53 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: What's needed for a PCIe card to be recognized?
Message-ID: <20080217015453.2a4e4142@dilbert.local>
In-Reply-To: <20080216143946.6d532a41@laptopd505.fenrus.org>
References: <20080216225932.22460d31@dilbert.local>
	<20080216143946.6d532a41@laptopd505.fenrus.org>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sat, 16 Feb 2008 14:39:46 -0800
schrieb Arjan van de Ven <arjan@infradead.org>:

> On Sat, 16 Feb 2008 22:59:32 +0100
> Hans-Jürgen Koch <hjk@linutronix.de> wrote:
> 
> > I'm playing around with a vanilla 2.6.25-rc1, adding patches to make
> > it work on an Asus EeePC. That one has the problem that its Mini
> > PCIe WLAN module doesn't show up in lspci. That brought up a few
> > questions that I couldn't answer yet:
> > 
> > How can they "hide" a PCIe card?
> > What could be their motive to do that?
> > How can I make it appear?
> 
> 
> go to the bios, enable the wireless card. 
> 
> that did it for me ;)

It didn't for me. I tried all combinations (booting with/without WLAN
enabled, enabling WLAN through /proc with/without pciehp loaded and so
on). What kernel did you use, and which patches did you apply?

Yes, I want to make it work, but I'd really like to understand what's
going on there and what's behind it.

Thanks,
Hans
