Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbYBWRzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbYBWRzg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYBWRz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:55:29 -0500
Received: from nn7.de ([85.214.94.156]:53950 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbYBWRz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:55:28 -0500
Subject: 2.6.25-current-git hangs on boot
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 23 Feb 2008 18:55:25 +0100
Message-Id: <1203789325.4063.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

trying out newest git, I see a hang with 
ACPI: SSDT 7feb9c10, 02ae (r1 APPLE CPU0Ist 3000 intl 20050309)
ACPI: SSDT 7feb9910, 02c3 (r1 APPLE CPU0Cst 3001 intl 20050309)
...
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7feb9f10, 0087 (r1 APPLE CPU1Ist 3000 intl 20050309)
ACPI: SSDT 7feb8f10, 0085 (r1 APPLE CPU1Cst 3001 intl 20050309)
...
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)

as the last message...

Any ideas?
Soeren
