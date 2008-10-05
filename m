Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbYJETLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbYJETLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbYJETKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:10:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:33006 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbYJETKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:10:50 -0400
Date: Sun, 5 Oct 2008 12:10:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc8+ - first impressions
Message-ID: <20081005121046.579089b9@infradead.org>
In-Reply-To: <20081005183603.GA3263@amd.corenet.prv>
References: <20081005183603.GA3263@amd.corenet.prv>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008 14:36:25 -0400
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> Hi,
> 
> Lats night I loaded 2.6.27-rc8-tip for the first time on my AMD Turion
> 64 laptop that is normally runs with Fedora distribution kernel.
> Compared to 2.6.25 the thing is broken - hdparm reports about 3MB/sec
> speed, fans are constantly on, everything seems sluggish.
> 
> Booting with hpet=force (HPET is disabled in BIOS) hangs the box
> somewhere in tty_init.

hpet=force is a "the kernel thinks it's not wise to use, but you think
better"... don't do that ;(


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
