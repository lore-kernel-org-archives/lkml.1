Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbXGaTyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbXGaTyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 15:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXGaTyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 15:54:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:65272 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbXGaTyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 15:54:09 -0400
Message-ID: <46AF935B.9020403@impulze.org>
Date: Tue, 31 Jul 2007 21:54:03 +0200
From: Daniel Mierswa <impulze@impulze.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Gericom Webboy Laptop Mouse/Touchpad
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/zh36ly3RUM8NcmfUS7oQr8//InOwr+PByzFh
 cjgaaDPtuvlACuXUGh8c3dEx6I/C2WBpI7pdBDTsmoB5J999gH
 SgFOtpHEjUNeGq4hhyMDw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi there,
i'm having troubles getting my mouse and/or touchpad to work with 
2.6.21.5 (and older ones). It's putting the following line into dmesg 
everytime the laptop gets lots of I/O or cpu load.
"psmouse.c: Wheel Mouse at isa0060/serio4/input0 lost synchronization, 
throwing 2 bytes away."
This happens for the touchpad and a newly brought PS/2 mouse. The cursor 
(be it gpm or X11) acts weird as in jumping around and clicking around 
without doing anything to it. As i searched about the string on google i 
found various tipps by removing ACPI (or even PM) from the kernel and retry.
I've tried following setups:
  No Power Management
  ACPI
  APM
  other clocksources (pit, tsc, acpi_pm)
The problem still exists and seems to occur as i've mentioned on lots of 
disk i/o and/or cpu load.
This is a laptop which is not supported by the manufactur anymore (seems 
to be a Gericom Webboy). I would appreciate any tips to debug this further.
Please post back for any additional information you need.

Thanks in advance.

-- 
MfG
Mierswa, Daniel
