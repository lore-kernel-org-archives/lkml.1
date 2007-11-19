Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbXKSNIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbXKSNIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXKSNIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:08:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38159
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752527AbXKSNIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:08:44 -0500
Date: Mon, 19 Nov 2007 05:08:43 -0800 (PST)
Message-Id: <20071119.050843.48408777.davem@davemloft.net>
To: paulus@samba.org
Cc: hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071114.172722.71465976.davem@davemloft.net>
References: <20071114.152134.266510129.davem@davemloft.net>
	<18235.40110.831730.847548@cargo.ozlabs.ibm.com>
	<20071114.172722.71465976.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Instead of blabbering further about this topic, I decided to put my
code where my mouth is and spent the weekend porting the perfmon2
kernel bits, and the user bits (libpfm and pfmon) to sparc64.

As a result I've found that perfmon2 is quite nice and allows
incredibly useful and powerful tools to be written.  The syscalls
aren't that bad and really I see not reason to block it's inclusion.

I rescind all of my earlier objections, let's merge this soon :-)
