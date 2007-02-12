Return-Path: <linux-kernel-owner+w=401wt.eu-S965379AbXBLUfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379AbXBLUfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965358AbXBLUfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:35:13 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:41601 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965379AbXBLUfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:35:12 -0500
Subject: Re: SATA-performance: Linux vs. FreeBSD
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: "Martin A. Fink" <fink@mpe.mpg.de>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070212190835.20f9b92f@localhost.localdomain>
References: <200702121502.17130.fink@mpe.mpg.de>
	 <200702121727.17108.fink@mpe.mpg.de> <p731wkvi5go.fsf@bingen.suse.de>
	 <200702121856.29729.fink@mpe.mpg.de>
	 <20070212190835.20f9b92f@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 07:34:48 +1100
Message-Id: <1171312488.4081.6.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan et al.

On Mon, 2007-02-12 at 19:08 +0000, Alan wrote:
> I'm not sure you'll get 50MB/sec sustained to work although you might
> with a good current drive used for nothing else, a linear stream of data
> (no seeking and file system overhead), and a non PCI controller (PCI
> Express, host chipset bus etc). 

That's Suspend2's usage pattern when given a whole partition, so I can
state without reservation you can get maximum throughput under those
circumstances, even with a PCI controller. Swsusp should do about the
same too.

Nigel

