Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbZCTPxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbZCTPxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbZCTPw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:52:59 -0400
Received: from mailserv58-us.natinst.com ([130.164.14.247]:3457 "EHLO
	mailserv58-us.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbZCTPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:52:59 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Mar 2009 11:52:59 EDT
From: Shawn Bohrer <shawn.bohrer@ni.com>
To: alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2 resend] Add support for National Instruments PCI RS232 devices
Date: Fri, 20 Mar 2009 10:37:25 -0500
Message-Id: <1237563447-12322-1-git-send-email-shawn.bohrer@ni.com>
X-Mailer: git-send-email 1.5.6.6
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.0.2|August 07, 2008) at
 03/20/2009 10:37:48 AM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.0.2|August 07, 2008) at
 03/20/2009 10:52:58 AM,
	Serialize complete at 03/20/2009 10:52:58 AM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series adds support for National Instruments PCI/PXI RS232 devices.
I've already sent these patches to the linux-serial list but haven't seen any
feedback nor have they gone into linux-next.  I'd like to have these go into
2.6.30 if possible so please let me know if anything needs to be changed or if
I need to send these patches to someone else since the 8250 driver is listed
as an orphan.

Thanks,
Shawn
