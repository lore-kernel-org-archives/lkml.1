Return-Path: <linux-kernel-owner+w=401wt.eu-S1767365AbXECESR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767365AbXECESR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 00:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767371AbXECESR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 00:18:17 -0400
Received: from c-69-254-139-13.hsd1.nm.comcast.net ([69.254.139.13]:51091 "EHLO
	deneb.dwf.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767365AbXECESQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 00:18:16 -0400
X-Greylist: delayed 1059 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 00:18:16 EDT
Message-Id: <200705030400.l4340bcD031447@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
To: linux-kernel@vger.kernel.org
Subject: I don' t understand this warning.
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 02 May 2007 22:00:37 -0600
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The last several kernels I have built all have the following warning in them:

WARNING: vmlinux - Section mismatch: reference to .init.text:start_kernel from 
.text between 'is386'
 (at offset 0xc0401171) and 'check_x87'
WARNING: vmlinux - Section mismatch: reference to .init.text: from .text 
between 'rest_init' (at off
set 0xc0401406) and 'try_name'
WARNING: vmlinux - Section mismatch: reference to .init.data: from .text 
between 'probe_bigsmp' (at
offset 0xc0402032) and 'init_apic_ldr'
WARNING: vmlinux - Section mismatch: reference to .init.text:find_unisys_acpi_o
em_table from .text b
etween 'acpi_madt_oem_check' (at offset 0xc0402244) and 'enable_apic_mode'

and this goes on with different variables for 18 lines.

Is this something I should be worried about?
I frankly dont understand what the message is trying to say.
-- 
                                        Reg.Clemens
                                        reg@dwf.com


