Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYF0PzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYF0PzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYF0Pyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:54:55 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63675 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752646AbYF0Pyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:54:53 -0400
Date: Fri, 27 Jun 2008 16:54:19 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip/master] x86: nmi_watchdog - documentation fix
In-Reply-To: <20080627154340.GC18957@cvg>
Message-ID: <Pine.LNX.4.55.0806271652020.8868@cliff.in.clinika.pl>
References: <20080627154340.GC18957@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008, Cyrill Gorcunov wrote:

> +NOTE: Prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
> +on x86 SMP boxes.

 While you are at it: s/is/was/.

  Maciej
