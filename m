Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbXBDP5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbXBDP5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 10:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbXBDP5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 10:57:51 -0500
Received: from lucidpixels.com ([75.144.35.66]:56038 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbXBDP5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 10:57:50 -0500
Date: Sun, 4 Feb 2007 10:57:50 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
Subject: Intel chooses not to support its HECI/QPS Chip in Linux?
Message-ID: <Pine.LNX.4.64.0702041050170.14035@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Anyone from Intel that reads LKML, could you provide an update as to what 
is happening with support for your HECI Controller/QPS chip, which is used 
on 965 (and possibly other?) chipsets.

I bought an Intel board, thinking everything would be supported, because 
it is an Intel board.  The board is an Intel DG965WHMKR.  Is Intel 
changing its values around open source?  Digging around, one will read 
something regarding Intel loads a special piece of code in the firmware of 
the chip.  Seems anti-open-source to me.  I believe a lot of people are 
interested in viewing their temperature of their chipsets, cpu, etc within
Linux, currently this is not possible.

What if any other types of motherboards are really fully supported in 
Linux these days?  Suffice to say, I am a bit surprised Intel has been 
quietly ignoring this for quite some time now.

Some of the discussion that has been going on regarding this issue:

http://softwareforums.intel.com/ISN/Community/en-US/forums/thread/30225715.aspx

"Hello, Intel(r) Quiet System Technology (QST) support is provided by the 
Firmware running the Management Engine.  Linux support, however, is not 
currently planned for QST and so there is no HECI driver for Linux.  G. Holmes"

http://www.lm-sensors.org/ticket/2134
http://www.lm-sensors.org/ticket/2153

Can anyone provide any update?

Justin.

