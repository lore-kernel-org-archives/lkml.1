Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYI3MH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYI3MH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYI3MG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:06:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54505 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752923AbYI3MGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:06:55 -0400
Date: Tue, 30 Sep 2008 13:06:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Dave Airlie <airlied@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
Message-ID: <20080930130628.31536c9a@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0809291923440.3389@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
	<Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>
	<alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
	<21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com>
	<20080929190612.111f16ac@infradead.org>
	<alpine.LFD.2.00.0809291921310.3389@nehalem.linux-foundation.org>
	<alpine.LFD.2.00.0809291923440.3389@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Mostly. I think you can still do bad things to internal LCD's on at least 
> some laptops. Although I hope I'm wrong. 

You still can in some cases. You can also erase many video card
firmwares, trash disks, brick DVD drives and the like fairly easily too
but you do tend to have to try to be evil in these cases, not just get an
address wrong.

Alan
