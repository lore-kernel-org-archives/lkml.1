Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbYDKTl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbYDKTl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 15:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbYDKTlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 15:41:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:60274 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272AbYDKTlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 15:41:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bqMaU/LVDrO6Bvp7/6HRxi1JlNIWbrM9IUIdPHqtvo8hb9zGfL9cHM9igjyHd0GeGN5/OTteIgsAzp6n1F/z3S06b2H3lco+zIvmE0ceek4f7p/23yOZzBriz9QhZtSITZd/O5nXHxNJjL0CjmtbHfonJm9wbbE7DLZP++4m4Us=
Message-ID: <a44ae5cd0804111241n7e6cbcadx1d9f66ed32dece1a@mail.gmail.com>
Date: Fri, 11 Apr 2008 15:41:17 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, len.brown@intel.com
Subject: 2.6.25-rc8-mm2 -- initcall acpi_init+0x0/0x216() returned with preemption imbalance
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this indicative of a kernel or hardware problem?

[    0.279606] ACPI: Using IOAPIC for interrupt routing
[    0.279789] initcall acpi_init+0x0/0x216() returned with preemption imbalance
[    0.330789] ACPI: PCI Root Bridge [PCI0] (0000:00)

Thanks,
       Miles
