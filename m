Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYIHM1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYIHM1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYIHM1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:27:43 -0400
Received: from mail.ocs.com.au ([202.134.241.204]:25105 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYIHM1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:27:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 (debian 1:2.7.2-12) with nmh-1.2
From: Keith Owens <kaos@ocs.com.au>
To: linux-kernel@vger.kernel.org
Subject: Recent copy of libpcap from CVS
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 08 Sep 2008 22:27:41 +1000
Message-ID: <963.1220876861@ocs10w>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anybody have a recent copy of the source to libpcap from its CVS
repository?

The normal site for libpcap (tcpdump.org) appears to have suffered a
filesystem crash and CVS is not working.  I am looking for a version of
libpcap that supports data capture for USB interfaces, the code will
probably have references to /dev/usbmon or a pcap-usb-linux.c file for
Linux.  libpcap0.8_0.9.8-2 is not recent enough.

