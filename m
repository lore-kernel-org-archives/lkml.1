Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbXIJPG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbXIJPG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 11:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759802AbXIJPGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 11:06:21 -0400
Received: from kuber.nabble.com ([216.139.236.158]:46338 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbXIJPGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 11:06:21 -0400
Message-ID: <12594726.post@talk.nabble.com>
Date: Mon, 10 Sep 2007 08:06:20 -0700 (PDT)
From: PnP driver <mkrameshid@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Calling PnP bios routines like get device node from x86_84 arch
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: mkrameshid@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,    
      I am very new to linux kernel driver development. I need to develop a 
driver for calling  BIOS routines like get device node. I could  call  it
in i386 architecture using the PnP driver. 
     But in x86_64 arch I couldn't see any support. Even I tried to
implement it similar to the i386. But there is no API get_cpu_gdt_table().
Is there any other way to get the cpu_gdt_table? or any other way to 
call the BIOS routines.

    Please help me on this.

-mkr



-- 
View this message in context: http://www.nabble.com/Calling-PnP-bios-routines-like-get-device-node-from-x86_84-arch-tf4415380.html#a12594726
Sent from the linux-kernel mailing list archive at Nabble.com.

