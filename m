Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbXLAUMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbXLAUMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 15:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXLAUMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 15:12:07 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:37279 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbXLAUMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 15:12:07 -0500
Date: Sat, 1 Dec 2007 21:11:58 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Bill Davidsen <davidsen@tmr.com>
Cc: LKML <linux-kernel@vger.kernel.org>, jakub@redhat.com
Subject: Re: Fedora's latest gcc produces unbootable kernels
Message-ID: <20071201211158.4700b222@poseidon.drzeus.cx>
In-Reply-To: <4751A9F8.1090505@tmr.com>
References: <20071201154223.1b052d39@poseidon.drzeus.cx>
	<20071201184752.33536d09@poseidon.drzeus.cx>
	<4751A9F8.1090505@tmr.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Dec 2007 13:37:44 -0500
Bill Davidsen <davidsen@tmr.com> wrote:

> If you are referring to the "compat" RPMs, be aware that they use the 
> current headers, which is a good or bad thing depending on what you want 
> to do. If you want to build old software, you get to keep a down-rev 
> virtual machine to do it right :-(
> 

Nah. The previous gcc package is the one shipped with Fedora 8. So I could just grab that one (plus cpp and libgomp) and downgrade.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
