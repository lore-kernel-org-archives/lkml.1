Return-Path: <linux-kernel-owner+w=401wt.eu-S933584AbXCUXJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584AbXCUXJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXCUXJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:09:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41650 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753099AbXCUXJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:09:47 -0400
Date: Thu, 22 Mar 2007 00:10:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-ID: <20070322001050.13588e5e@lxorguk.ukuu.org.uk>
In-Reply-To: <20070321151952.02b5612d.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6>
	<p73y7lu5yt6.fsf@bingen.suse.de>
	<20070320165736.GA19781@redhat.com>
	<20070320181442.1ae73295@lxorguk.ukuu.org.uk>
	<20070321151952.02b5612d.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is a user visible API it is therefore not elligable for removal
> > anyway
> 
> mutter.
> 
> We've given people years of notice and _some_ applications have converted
> over to open("/dev/sda1", O_DIRECT), as they should.

Linus said we don't break old applications by removing APIs. People
believe him. 

Alan
