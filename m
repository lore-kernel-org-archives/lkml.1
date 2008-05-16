Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbYEPRoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbYEPRoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYEPRn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:43:58 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56021 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbYEPRn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:43:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 16 May 2008 19:43:43 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/5] SCSI and FireWire: fix/add START STOP UNIT for SBP-2
 disks
To: Tino Keitel <tino.keitel@gmx.de>
cc: linux1394-devel@lists.sourceforge.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20080516062315.GA4350@dose.home.local>
Message-ID: <tkrat.ad2cb91dd8644559@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
 <481874BD.5010807@s5r6.in-berlin.de>
 <20080507180042.GA32629@dose.home.local>
 <tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
 <tkrat.635f52f7035be2bc@s5r6.in-berlin.de>
 <tkrat.5cf7605228f0006a@s5r6.in-berlin.de>
 <20080516062315.GA4350@dose.home.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel wrote:
> I applied all patches, and tried it on my system with a SATA, USB and
> Firewire disk. All disks spun down at suspend, and spun up again at
> resume.

So can I add "Tested-by: Tino Keitel <tino.keitel@gmx.de>" to the
changelog of patches 1/5, 2/5, 4/5 (the patches affecting sd and
fw-sbp2)?

Thanks for testing, and for finding in the first place that we need the
power conditions field.
-- 
Stefan Richter
-=====-==--- -=-= =----
http://arcgraph.de/sr/

