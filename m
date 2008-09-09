Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbYIIAHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbYIIAHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 20:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYIIAHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 20:07:35 -0400
Received: from mail.ocs.com.au ([202.134.241.204]:20785 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbYIIAHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 20:07:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 (debian 1:2.7.2-12) with nmh-1.2
From: Keith Owens <kaos@ocs.com.au>
To: Patrick McHardy <kaber@trash.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: Recent copy of libpcap from CVS 
In-reply-to: Your message of "Mon, 08 Sep 2008 14:45:12 +0200."
             <48C51E58.7080900@trash.net> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 09 Sep 2008 10:07:32 +1000
Message-ID: <19419.1220918852@ocs10w>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy (on Mon, 08 Sep 2008 14:45:12 +0200) wrote:
>Keith Owens wrote:
>> Does anybody have a recent copy of the source to libpcap from its CVS
>> repository?
>> 
>> The normal site for libpcap (tcpdump.org) appears to have suffered a
>> filesystem crash and CVS is not working.  I am looking for a version of
>> libpcap that supports data capture for USB interfaces, the code will
>> probably have references to /dev/usbmon or a pcap-usb-linux.c file for
>> Linux.  libpcap0.8_0.9.8-2 is not recent enough.
>
>Dave put a recent copy up at:
>
>git://git.kernel.org/pub/scm/linux/kernel/git/davem/libpcap.git

Thanks, but that is still version 0.9.8 with no support for usb.
It defines DLT_USB and DLT_USB_LINUX but has no code to actually
read from /dev/usbmon.  I need the CVS version of libpcap.

