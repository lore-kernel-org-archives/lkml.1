Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZEENA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZEENA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZEENAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:00:11 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:49477 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZEENAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:00:10 -0400
X-Greylist: delayed 2911 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 May 2009 09:00:10 EDT
Message-ID: <4A002CF8.4070504@xs4all.nl>
Date: Tue, 05 May 2009 14:11:36 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ACPI: I/O resource w83627hf [0x295-0x296] conflicts with ACPI region
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Booted into 2.6.29.2 on VIA Epia EK8000.
Saw these lines:

w83627hf: Found W83697HF chip at 0x290
ACPI: I/O resource w83627hf [0x295-0x296] conflicts with ACPI region 
IP__ [0x295-0x296]
ACPI: Device needs an ACPI driver

Is anybody looking into this ACPI-driver issue?

(yes there was an issue with regiosn being reserved versus BIOS, etc, 
some time ago)

Kind regards,
Udo
