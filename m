Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbXLBBvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbXLBBvX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 20:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbXLBBvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 20:51:15 -0500
Received: from bay0-omc3-s4.bay0.hotmail.com ([65.54.246.204]:20467 "EHLO
	bay0-omc3-s4.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323AbXLBBvO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 20:51:14 -0500
Message-ID: <BAY113-W62BC3D470D7BA8C731FF984730@phx.gbl>
X-Originating-IP: [76.198.157.220]
From: Scott Noone <nwi_sub@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: 2.6.23.9, make install doesn't work with grub anymore??
Date: Sat, 1 Dec 2007 20:51:14 -0500
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 02 Dec 2007 01:51:14.0448 (UTC) FILETIME=[D25A3100:01C83485]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I downloaded the vanilla kernels 2.6.23.8 and 2.6.23.9 from kernel.org.  I unpacked them like I have every other kernel release.  I compiled the kernel successfully, did the make modules and make modules_install with no problems.  When I did the make install I am told it Cannot find LILO.  The message seems to come from /usr/src/linux-2.6.23.9/arch/i386/boot/install.sh
The script is correct that I don't have lilo installed, I have used grub for quite some time.  I don't remember having this problem with older kernels, sorry I don't remember one of the top of head.  Did something change or is:
cp .config /usr/src/linux-2.6.23-9
make menuconfig
make
make modules
make modules_install
make install
no longer adequate to compile and install a kernel?

Thanks,
Scott
_________________________________________________________________
Share life as it happens with the new Windows Live.Download today it's FREE!
http://www.windowslive.com/share.html?ocid=TXT_TAGLM_Wave2_sharelife_112007