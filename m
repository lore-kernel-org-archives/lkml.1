Return-Path: <linux-kernel-owner+w=401wt.eu-S933174AbXAaRta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbXAaRta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXAaRt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:49:29 -0500
Received: from morgan.checkgiant.com ([72.9.244.66]:51854 "EHLO
	morgan.cashnetusa.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174AbXAaRt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:49:29 -0500
X-Greylist: delayed 1139 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jan 2007 12:49:29 EST
Subject: Unidentified Intel wifi network card
From: Scott Lockwood <lkml@lrsehosting.com>
Reply-To: wsl3@lrsehosting.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: alan@redhat.com
Content-Type: text/plain
Organization: LRSE Hosting
Date: Wed, 31 Jan 2007 11:30:23 -0600
Message-Id: <1170264624.5569.15.camel@scott-640m>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking for assistance with a wifi device I can't find a driver for,
the Intel Wireless 3945.

I"m getting this:

0000:0c:00.0 Network controller: Intel Corporation: Unknown device 4222
(rev 02)

on a new Dell Latitude D820. Anyone know if there will be an open source
driver for this any time soon, or if there is one now?

I'm using the latest vendor supplied kernel, so my apologies if this has
already been done and I'm late to the party. I wasn't able to find much,
other than 'use the NDIS wrapper' which I really don't want to do.

Thanks for any assistance, at all,
Scott

