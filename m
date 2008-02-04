Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYBDOXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYBDOXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYBDOX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:23:29 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39125 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750909AbYBDOX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:23:28 -0500
Date: Mon, 4 Feb 2008 14:18:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "CooperYuan Cooper" <cooperyuan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: About closed-source module use GPL module function
Message-ID: <20080204141800.74c8615f@core>
In-Reply-To: <a9cbba340801292241y1e5e553dnbcb6734e57935832@mail.gmail.com>
References: <a9cbba340801292241y1e5e553dnbcb6734e57935832@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 14:41:24 +0800
"CooperYuan Cooper" <cooperyuan@gmail.com> wrote:

> Hi all,
> 
> Now I am porting a device driver to Linux, its source code is not opened.
> 
> In this module, I use some interface functions exported from GPL
> module through EXPORT_SYMBOL macros. (not EXPORT_SYMBOL_GPL), For
> example, register_sound_dsp() and so on.
> 
> Do I violate GPL? How to solve it?

You should consult your company lawyer.

Alan
