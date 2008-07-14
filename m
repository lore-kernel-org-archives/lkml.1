Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbYGNHSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbYGNHSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbYGNHSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:18:39 -0400
Received: from aa.81.b6.static.xlhost.com ([207.182.129.170]:38143 "EHLO
	wombat.diezmil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbYGNHSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:18:38 -0400
X-Greylist: delayed 3695 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2008 03:18:38 EDT
Date: Mon, 14 Jul 2008 10:10:21 -0400
From: eng_azza_kamal@hotmail.com
Reply-To: eng_azza_kamal@hotmail.com
To: linux-kernel@vger.kernel.org
Message-ID: <4064057.21216044621697.JavaMail.root@wombat.diezmil.com>
Subject: USB Mounting Problem
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Dear all , 

I have linux kernel running on an ARM platform. The problem is that the linux kernel doesn't recognize the USB flash if it was inserted before booting up the system.
If the flash is inserted after the boot up of the kernel the flash is given the node /dev/sda1 or /dev/sdb1 and I can mount it. 
My question is how to recognize the flash if it was inserted in the system before booting of the kernel. 
I recompiled the kernel to include both scsi and usb storage (not to be as modules) but this doesn't work.

Need your support please

--
This message was sent on behalf of eng_azza_kamal@hotmail.com at openSubscriber.com
http://www.opensubscriber.com/messages/linux-kernel@vger.kernel.org/topic.html
