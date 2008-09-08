Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbYIHMp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbYIHMp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYIHMpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:45:17 -0400
Received: from stinky.trash.net ([213.144.137.162]:41095 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYIHMpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:45:16 -0400
Message-ID: <48C51E58.7080900@trash.net>
Date: Mon, 08 Sep 2008 14:45:12 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Keith Owens <kaos@ocs.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: Recent copy of libpcap from CVS
References: <963.1220876861@ocs10w>
In-Reply-To: <963.1220876861@ocs10w>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Owens wrote:
> Does anybody have a recent copy of the source to libpcap from its CVS
> repository?
> 
> The normal site for libpcap (tcpdump.org) appears to have suffered a
> filesystem crash and CVS is not working.  I am looking for a version of
> libpcap that supports data capture for USB interfaces, the code will
> probably have references to /dev/usbmon or a pcap-usb-linux.c file for
> Linux.  libpcap0.8_0.9.8-2 is not recent enough.

Dave put a recent copy up at:

git://git.kernel.org/pub/scm/linux/kernel/git/davem/libpcap.git
