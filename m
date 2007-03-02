Return-Path: <linux-kernel-owner+w=401wt.eu-S933322AbXCBLRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322AbXCBLRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933335AbXCBLRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:17:31 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36861 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933322AbXCBLRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:17:31 -0500
Date: Fri, 2 Mar 2007 12:21:30 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Werner LEMBERG <wl@gnu.org>, linux-kernel@vger.kernel.org
Subject: Re: Memory stick reader Ricoh R5C592 supported?
Message-ID: <20070302122130.2004419d@lxorguk.ukuu.org.uk>
In-Reply-To: <45E7F13E.60408@drzeus.cx>
References: <20070302.102351.146595518.wl@gnu.org>
	<45E7F13E.60408@drzeus.cx>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Memory stick is completely unsupported. We haven't got any specs for neither the
> the host controllers or the protocol. So I would guess it would be quite some
> time before memorystick is supported directly by Linux.

Don't hold your breath either. The reverse engineering work done a long
time ago on some of the memory sticks suggests the "security" (DRM)
features are actually done in software by the driver so I doubt we'll see
specs soon.

Alan
