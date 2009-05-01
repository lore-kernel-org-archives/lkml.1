Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbZEAEeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbZEAEeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 00:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbZEAEeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 00:34:12 -0400
Received: from n62.bullet.mail.sp1.yahoo.com ([98.136.44.35]:48026 "HELO
	n62.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750757AbZEAEeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 00:34:11 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 457720.73352.bm@omp115.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=ZfMioMefP1fiOc/yCuSfv2SsHyzdHj9pxg4LdZfV/uumsB/vci31pfLu1PGJvji+IcE2f49DMyhCVlb2FAqyIDt7xpZqZCfEIsw16RDrwKcaAzFwp85/068NgIPW8k+q66sWgllfxuPvTuUYR1tQODBAR7tVq9+5ElquHUWlj9k=;
Message-ID: <281401.52512.qm@web112204.mail.gq1.yahoo.com>
X-YMail-OSG: 4Ll0YxAVM1nkDhGNILN9EgivGWFxkOytIqhtH.eV9ARzGS6eg7MVx7vp9mf8c1bvrsjFgAMg2stW2lhLSd5Fab7WIC4Cpz5CCc_gxX8ojolQJa_7jvdoYk7KgQr_QsY2N5eVyWmMgqrh6BGZJsj2AzbP2yqhxknHQWI5nkJAnzoilno6gwtqAKLNnGCi_hDXE76xOu.F2Ws7ked26hIGT0xuYEkr6QOnvxfz.X9zeaT80eVuNisEkTKglGH8H2KxDmpQumnTIe3YkRa3Vzxnmf1JQQriNDd8A6eCEDuMSi715gZSGM_xVFgseev.aZf.f_PZN12EzRxJ8idcOoXn2_g-
X-Mailer: YahooMailClassic/5.2.20 YahooMailWebService/0.7.289.1
Date: Thu, 30 Apr 2009 21:34:10 -0700 (PDT)
From: We La <w.landgraf@yahoo.com>
Subject: regression with video and i915 module
To: akpm@linux-foundation.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
       davidjon@xenontk.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The error messages with 2.6.30-rc4 are more than before:

Apr 30 23:35:17 localhost kernel: i915: Unknown symbol acpi_video_exit
Apr 30 23:35:17 localhost kernel: i915: Unknown symbol acpi_video_register

This is like before a MSI wind U100 laptop


On this ocasion, I want to mention that also the broadcom 43 wifi driver dont work correctly. This cards are in HP, Compac, Toshiba laptops.  The driver needs additionally the extraction of firmware from Windows drivers and installation in /lib/firmware, and even then it functions problematically. Often nor the light that the wifi works goes on. The programmers of that should be notified to repair the driver that he dont depend longer on firmware.

On the same time, the rt2860sta driver for wifi on my own laptop works without problems, my server works via wifi with this driver and I up-/download many, no problems with that driver.


Werner Landgraf



      

