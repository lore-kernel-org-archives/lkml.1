Return-Path: <linux-kernel-owner+w=401wt.eu-S1764026AbXGXAqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764026AbXGXAqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 20:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbXGXApw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 20:45:52 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:24999 "EHLO
	asav04.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbXGXApv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 20:45:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusRAPDnpEZKhRO4Rmdsb2JhbACHNIgdAQEBIwYMAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [patch 1/3] m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible
Date: Mon, 23 Jul 2007 20:45:45 -0400
User-Agent: KMail/1.9.3
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org
References: <20070720164043.523003359@mail.of.borg> <200707220022.41797.dtor@insightbb.com> <Pine.LNX.4.64.0707221451140.18493@anakin>
In-Reply-To: <Pine.LNX.4.64.0707221451140.18493@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707232045.47104.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2007 08:51, Geert Uytterhoeven wrote:
> On Sun, 22 Jul 2007, Dmitry Torokhov wrote:
> > On Saturday 21 July 2007 04:27, Geert Uytterhoeven wrote:
> > > On Fri, 20 Jul 2007, Dmitry Torokhov wrote:
> > > > I am OK with adding a new header file. I was just saying that placing
> > > > that declaration in linux/hid.h makes about the same sense as putting
> > > > it into linux/scsi.h
> > > 
> > > At first I just wanted to move it. Then I thought about the angry
> > > comments I would get about not moving it to a header file ;-)
> > > 
> > > <linux/hid.h> looked like the best candidate. <linux/kbd_kern.h> is
> > > another option.
> > > 
> > 
> > linux/kbd_kern.h sounds much better.
> 
> And so it will be.

Applied to 'for-linus' branch of input tree, thank you.

-- 
Dmitry
