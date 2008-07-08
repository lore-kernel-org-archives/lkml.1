Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYGHTf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYGHTf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 15:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYGHTfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 15:35:47 -0400
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:35908 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751801AbYGHTfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 15:35:46 -0400
X-Greylist: delayed 1315 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jul 2008 15:35:46 EDT
Message-ID: <4873BCD5.5060407@vlnb.net>
Date: Tue, 08 Jul 2008 23:15:33 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
CC: scst-devel <scst-devel@lists.sourceforge.net>
Subject: [ANNOUNCE]: Target drivers for QLogic Fibre Channel cards released
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm glad to announce that version 1.0.0 of target drivers for QLogic 
Fibre Channel cards released and available for download from 
http://scst.sourceforge.net/downloads.html.

Two target drivers were released:

   - Target driver qla2x00t for 22xx and 23xx based QLogic Fibre Channel 
cards

   - Target driver qla_isp for 24xx based QLogic Fibre Channel cards

Those drivers are designed to work in SCST environment. They are high 
performance drivers, which provide all necessary functionality to work 
as targets in Fibre Channel environment.

Detail description of the target drivers you can find on SCST home page 
http://scst.sourceforge.net.

Driver qla2x00t is being prepared in form of patch for review and 
inclusion into the kernel.

Vlad
