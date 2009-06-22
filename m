Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbZFVPCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbZFVPCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZFVPCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:02:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44856 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753426AbZFVPCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:02:23 -0400
Date: Mon, 22 Jun 2009 11:02:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Marek Szyprowski <m.szyprowski@samsung.com>
cc: "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       <kyungmin.park@samsung.com>
Subject: RE: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
In-Reply-To: <001301c9f343$7e16ed80$7a44c880$%szyprowski@samsung.com>
Message-ID: <Pine.LNX.4.44L0.0906221101490.3081-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Marek Szyprowski wrote:

> > This is just a guess...  But there's a good possibility that the oops
> > was caused by recent changes to the serial layer which have not been
> > propagated through to the g_serial driver.
> 
> How recent these changes are? I did a test on another ARM-based Linux 
> platform with old 2.6.28 kernel and the result was exactly the same as 
> above...

I think the changes are new in 2.6.30.  So they aren't the reason for 
you oops, after all.

Alan Stern

