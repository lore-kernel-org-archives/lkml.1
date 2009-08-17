Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbZHQUFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbZHQUFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757644AbZHQUFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:05:20 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:60864 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754446AbZHQUFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:05:19 -0400
Date: Mon, 17 Aug 2009 16:05:15 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: len.brown@intel.com
cc: linux-kernel@vger.kernel.org
Subject: 2.6.31-rc5: ACPI Error: Null physical address
Message-ID: <alpine.DEB.1.10.0908171603130.20399@gentwo.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dell R610 (Nehalem 2.93Ghz Dual Quad)


[    0.000000] ACPI: ERST 00000000bf6b2390 00270 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: HEST 00000000bf6b2600 0027C (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: BERT 00000000bf6b2210 00030 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: EINJ 00000000bf6b2240 00150 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI Error: Null physical address for ACPI table [<NULL>] 20090521 tbutils-313
[    0.000000] ACPI: TCPA 00000000bf6c3bc0 00064 (v02 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000

