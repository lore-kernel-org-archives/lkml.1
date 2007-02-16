Return-Path: <linux-kernel-owner+w=401wt.eu-S1423296AbXBPFpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423296AbXBPFpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 00:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423297AbXBPFpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 00:45:21 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50965 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423296AbXBPFpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 00:45:20 -0500
Date: Thu, 15 Feb 2007 21:45:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Tobias Hain <tobias.hain@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Don't probe for DDC on VBE1.2
Message-Id: <20070215214506.f795acc4.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702152134190.12571@montezuma.fsmlabs.com>
References: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
	<20070215205658.56096f97.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702152134190.12571@montezuma.fsmlabs.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 21:35:35 -0800 (PST) Zwane Mwaikambo <zwane@infradead.org> wrote:

> On Thu, 15 Feb 2007, Andrew Morton wrote:
> 
> > This makes the long-suffering-but-vigorously-defended Vaio come up with a
> > black display.  Everything's working OK otherwise.  Sort of a Black Screen
> > of Life.  I wouldn't call it an improvement though.
> 
> Bugger, what does your kernel commandline look like?

Kernel command line: ro root=LABEL=/ rhgb vga=0x263 clock=pit

http://userweb.kernel.org/~akpm/dmesg-sony.txt
