Return-Path: <linux-kernel-owner+w=401wt.eu-S933238AbZJOQ34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbZJOQ34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760788AbZJOQ3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:29:55 -0400
Received: from lucidpixels.com ([75.144.35.66]:38684 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757978AbZJOQ3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:29:55 -0400
Date: Thu, 15 Oct 2009 12:29:18 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: bruce.w.allan@intel.com
Subject: Linux* is not supported on the Intel(R) Desktop Board DP55KG - Kernel
 still hangs upon reboot.
Message-ID: <alpine.DEB.2.00.0910151226000.10075@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Bruce, it looks like that is coming from here:
http://www.intel.com/support/motherboards/desktop/sb/CS-008326.htm

Is there any workaround for the reboot problem?
http://www.gossamer-threads.com/lists/linux/kernel/1141848?do=post_view_threaded

It looks like there was a similar bug on 965 motherboards, in which, Intel 
issued a BIOS update that fixed it:
http://lkml.indiana.edu/hypermail/linux/kernel/0610.2/2215.html

Is Intel aware of this-- is there any communication/channels a customer 
can utilize (besides LKML) to ask Intel about the status/ETA on a fix for 
this issue?

Justin.
