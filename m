Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbYJ1L3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbYJ1L3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 07:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYJ1L3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 07:29:08 -0400
Received: from mail01.dbd-breitband.de ([89.199.255.35]:48957 "EHLO
	mail01.dbd-breitband.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYJ1L3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 07:29:07 -0400
X-Greylist: delayed 1830 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2008 07:29:07 EDT
Subject: tg3:No interrupt was generated using MSI, switching to INTx mode.
	Please report this failure to the PCI maintainer and include system chipset
	information.
From: Marc Donner <donner@dbd-breitband.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 11:58:30 +0100
Message-ID: <1225191510.26840.6.camel@localhost>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi @all,

we have installed a dual port Brodcam Gigabit Ethernet NIC, and get the
following error in dmesg:

tg3: eth1 No interrupt was generated using MSI, switching to INTx mode.
Please report this failure to the PCI maintainer and include system
chipset information.

Who is responsible for this error message? We are using Kernel 2.6.21.1
and the NIC Chipset is a Broadcom BCM5715CKPBG

Regards,

Marc

