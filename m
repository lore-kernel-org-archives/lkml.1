Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbZI2Ke7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbZI2Ke7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZI2Ke7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:34:59 -0400
Received: from mail142.messagelabs.com ([216.82.249.99]:15934 "HELO
	mail142.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752810AbZI2Ke6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:34:58 -0400
X-VirusChecked: Checked
X-Env-Sender: Haneef.Syed@lntinfotech.com
X-Msg-Ref: server-12.tower-142.messagelabs.com!1254220275!79890071!2
X-StarScan-Version: 6.1.3; banners=lntinfotech.com,-,-
X-Originating-IP: [203.101.96.4]
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: cpu affinity issue on kvm-88
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
Message-ID: <OFE960567D.0F132D09-ON65257640.0039A660-65257640.003A00F4@lntinfotech.com>
From: Haneef Syed <Haneef.Syed@lntinfotech.com>
Date: Tue, 29 Sep 2009 16:03:33 +0530
X-MIMETrack: Serialize by Router on BANGALORE/LNTINFOTECH(Release 7.0.3|September 26, 2007) at
 09/29/2009 04:03:58 PM,
	Serialize complete at 09/29/2009 04:03:58 PM,
	Itemize by SMTP Server on BangaloreSMTP/LNTINFOTECH(Release 7.0.3|September
 26, 2007) at 09/29/2009 04:05:20 PM,
	Serialize by Router on BangaloreSMTP/LNTINFOTECH(Release 7.0.3|September 26, 2007) at
 09/29/2009 04:06:23 PM,
	Serialize complete at 09/29/2009 04:06:23 PM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
   Actually I am using 2.6.21 kernel and inserting kvm-76 module.

   It is fine when I am using cpu affinity( like  " taskset 1 
./qemu-system-x86-64  -hda imgage name ").

   I am having quad core intel xeon processor.

  But without cpu affinity It is hanging randomly.(./qemu-system-x86-64 
-hda imgage name)

  Give me any suggestion


______________________________________________________________________
