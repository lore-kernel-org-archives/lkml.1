Return-Path: <linux-kernel-owner+w=401wt.eu-S2992475AbXCWPxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992475AbXCWPxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 11:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992470AbXCWPxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 11:53:41 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33021 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992475AbXCWPxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 11:53:40 -0400
X-Originating-Ip: 74.109.98.130
Date: Fri, 23 Mar 2007 11:50:24 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Marcel Siegert <mws@linuxtv.org>
cc: v4l-dvb-maintainer@linuxtv.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] DVB: Delete unused header file
 linux/dvb/version.h.
In-Reply-To: <200703231647.53780.mws@linuxtv.org>
Message-ID: <Pine.LNX.4.64.0703231149420.30705@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703231130480.30201@CPE00045a9c397f-CM001225dbafb6>
 <200703231647.53780.mws@linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_DV 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, Marcel Siegert wrote:

> On Friday 23 March 2007, Robert P. J. Day wrote:
> >
> > Delete the unreferenced header file include/linux/dvb/version.h.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> NACK
> this header is unreferenced in kernel, but used for applications that compile for userspace
> to determine the api version.

ah.  i didn't notice that that file was being exported to userspace.
my fault.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
