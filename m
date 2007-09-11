Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbXIKO4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbXIKO4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbXIKO4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:56:13 -0400
Received: from cicero-fbr1.cybercity.dk ([212.242.40.5]:62125 "EHLO
	cicero-fbr1.cybercity.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbXIKO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:56:12 -0400
X-Greylist: delayed 2725 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2007 10:56:12 EDT
Subject: Slightly OT: Unable to wake-up after suspend
From: Mark Rosenstand <mark@borkware.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 11 Sep 2007 16:10:45 +0200
Message-Id: <1189519845.27446.40.camel@abfahrt.borkware.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just gave the CentOS 5.0 live CD a spin and wanted to see if suspend
worked. The system did suspend but I'm unable to make it wake-up again,
at all.

I've tried unplugging the power cord, resetting CMOS, removing the BIOS
battery and all RAM. The system shows no sign of life except the
motherboard LED, unless I power it on with the CLRTC jumper activated in
which case the CPU FAN and harddisk starts, but still no monitor signal.

This is a Asus K8V-X motherboard[1] with ECC RAM and the system has been
rock solid for almost 3 years despite daily abuse (build machine).

Any advice would be greatly appreciated.

[1]
http://www.asus.com.tw/products.aspx?l1=3&l2=14&l3=67&l4=0&model=237&modelmenu=2

