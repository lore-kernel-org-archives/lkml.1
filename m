Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbXLaG12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbXLaG12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 01:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXLaG1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 01:27:20 -0500
Received: from hpcnc.cpe.ku.ac.th ([158.108.34.34]:33065 "EHLO
	hpcnc.cpe.ku.ac.th" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbXLaG1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 01:27:19 -0500
X-Greylist: delayed 2875 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Dec 2007 01:27:19 EST
Date: Mon, 31 Dec 2007 12:39:11 +0700 (ICT)
From: Theewara Vorakosit <thvo@hpcnc.cpe.ku.ac.th>
To: linux-kernel@vger.kernel.org
Subject: Get physical MAC address
Message-ID: <Pine.LNX.4.44.0712311233290.17732-100000@hpcnc.cpe.ku.ac.th>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I get MAC address from ioctl. However, ifconfig can change this  MAC 
address. Can I get a real physical MAC address of the NIC?

Thanks,
Theewara

