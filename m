Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0BMBkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:40:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:20244 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab0BMBkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:40:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208";a="595625699"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Feb 2010 17:39:57 -0800
Subject: [PATCH 0/9] x86: Preparation patches for Moorestown
Thread-Topic: [PATCH 0/9] x86: Preparation patches for Moorestown
Thread-Index: AcqsTXNBaQhgQoA3QK6vSy/fYWApAQ==
Message-ID: <43F901BD926A4E43B106BF17856F07559FB80CFC@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series prepare the abstraction needed for smooth integration of
Moorestown specific code.

Most of the patches in this series are just rebase of x86/mrst branch in tip
tree, which has been posted earlier.

0001-PCI-add-pci_bus_find_ext_capability.patch
0002-x86-Move-pci-init-function-to-x86_init.patch
0003-x86-Add-pci_init_irq-to-x86_init.patch
0004-x86-Add-pcibios_fixup_irqs-to-x86_init.patch
0005-x86-ioapic-improve-handling-of-i8259a-irq-init.patch
0006-x86-initialize-stack-canary-in-secondary-start.patch
0007-x86-pic-introduce-legacy_pic-abstraction.patch
0008-x86-pic-make-use-of-legacy_pic-abstraction.patch
0009-x86-apic-remove-ioapic_disable_legacy.patch


Jacob Pan
Linux Software Engineer
Intel Open Source Technology Center


