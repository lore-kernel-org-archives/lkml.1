Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbYIIALQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbYIIALQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 20:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYIIALD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 20:11:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60069
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753864AbYIIALC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 20:11:02 -0400
Date: Mon, 08 Sep 2008 17:10:55 -0700 (PDT)
Message-Id: <20080908.171055.170770457.davem@davemloft.net>
To: kaos@ocs.com.au
Cc: kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: Recent copy of libpcap from CVS 
From: David Miller <davem@davemloft.net>
In-Reply-To: <19419.1220918852@ocs10w>
References: <48C51E58.7080900@trash.net>
	<19419.1220918852@ocs10w>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Owens <kaos@ocs.com.au>
Date: Tue, 09 Sep 2008 10:07:32 +1000

> Patrick McHardy (on Mon, 08 Sep 2008 14:45:12 +0200) wrote:
> >Keith Owens wrote:
> >> Does anybody have a recent copy of the source to libpcap from its CVS
> >> repository?
> >> 
> >> The normal site for libpcap (tcpdump.org) appears to have suffered a
> >> filesystem crash and CVS is not working.  I am looking for a version of
> >> libpcap that supports data capture for USB interfaces, the code will
> >> probably have references to /dev/usbmon or a pcap-usb-linux.c file for
> >> Linux.  libpcap0.8_0.9.8-2 is not recent enough.
> >
> >Dave put a recent copy up at:
> >
> >git://git.kernel.org/pub/scm/linux/kernel/git/davem/libpcap.git
> 
> Thanks, but that is still version 0.9.8 with no support for usb.
> It defines DLT_USB and DLT_USB_LINUX but has no code to actually
> read from /dev/usbmon.  I need the CVS version of libpcap.

Sorry that's the most recent CVS tree Patrick had when I built that
GIT repo.
