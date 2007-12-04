Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbXLDNWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbXLDNWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbXLDNWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:22:06 -0500
Received: from relais.videotron.ca ([24.201.245.36]:21056 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbXLDNWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:22:05 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 04 Dec 2007 08:22:03 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc4
In-reply-to: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org>
Message-id: <alpine.LFD.0.99999.0712040819080.555@xanadu.home>
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org>
User-Agent: Alpine 0.99999 (LFD 814 2007-11-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007, Linus Torvalds wrote:

> That said, none of the changes are really _exciting_ or really scary. And 
> we should have fixed a number of regressions, although more certainly 
> remain.

Any reason for this:

 mode change 100644 => 100755 drivers/net/chelsio/cxgb2.c
 mode change 100644 => 100755 drivers/net/chelsio/pm3393.c
 mode change 100644 => 100755 drivers/net/chelsio/sge.c
 mode change 100644 => 100755 drivers/net/chelsio/sge.h


Nicolas
