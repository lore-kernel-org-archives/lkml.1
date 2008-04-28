Return-Path: <linux-kernel-owner+w=401wt.eu-S968752AbYD1XN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968752AbYD1XN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968223AbYD1XKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:10:42 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:59127 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968313AbYD1XKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:10:40 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2008 19:10:40 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsABAK71FUh5LSUG/2dsb2JhbAAIrC0
X-IronPort-AV: E=Sophos;i="4.25,718,1199626200"; 
   d="scan'208";a="104553020"
Message-ID: <48165836.5010107@The-Pearces.com>
Date: Tue, 29 Apr 2008 08:35:26 +0930
From: Lyall Pearce <Lyall@The-Pearces.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: usb_submit_urb returns -38 - help?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
My apologies if this is the incorrect group to post this question.
I have linux kernel 2.6.24, from Gentoo r4.
I am attempting to establish a webcam (MSI StarCam 370i).
I have this webcam plugged into a USB Hub.
I have established video4linux in the kernel.
I have installed drivers gspcav1.
The camera is recognised.
When I attempt to use the webcam, I receive a failure from
usb_submit_urb of value -38.

For further info, you can refer to my request for help in the Gentoo forums, http://forums.gentoo.org/viewtopic-t-690101-highlight-.html

If further info is required, please ask.

...Lyall



