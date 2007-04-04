Return-Path: <linux-kernel-owner+w=401wt.eu-S966271AbXDDCPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966271AbXDDCPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966278AbXDDCPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:15:52 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:29601 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966271AbXDDCPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:15:52 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 22:15:52 EDT
Date: Tue, 3 Apr 2007 21:05:51 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404020551.GA1287122@hiwaay.net>
References: <fa.RNOVtHsCnerNJiCxv9p57P7pZcA@ifi.uio.no> <fa.dSkcKtgkzrihvFnFz6eHJ4FfEqo@ifi.uio.no> <fa.QUe06itDHMey7lWZGdbZCBEo+KI@ifi.uio.no> <fa.Hc/xBcsQlAMlaXgROFi/tmfDmUc@ifi.uio.no> <fa.lmdJmRWPjSVEElYwPlXT98ZHiMc@ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403230908.GA13471@cynthia.pants.nu>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Brad Boyer  <flar@allandria.com> said:
>The point is that people are used to having "ttyS0" mean the first
>onboard serial port.

My first serial port is a USB dongle and is ttyUSB0.  If the argument is
that all serials should be ttyS[0-9]+, are you going to change USB
adapters as well?
