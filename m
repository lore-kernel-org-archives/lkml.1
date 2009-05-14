Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZENUbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZENUbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbZENUba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:31:30 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:26030 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbZENUb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:31:29 -0400
Subject: [PATCH 0/2] cleanups in drivers/acpi/scan.c
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 14 May 2009 08:31:26 -0600
Message-ID: <20090514142941.18569.75813.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

I'm investigating some cleanups in ACPI/PCI bindings, and figured I'd
send these trivial cleanup patches while I work on the real issues.

Thanks.

/ac

---

Alex Chiang (2):
      ACPI: clean up whitespace in drivers/acpi/scan.c
      ACPI: acpi_device_register() should call device_register()


 drivers/acpi/scan.c |   49 ++++++++++++++++++++++---------------------------
 1 files changed, 22 insertions(+), 27 deletions(-)

