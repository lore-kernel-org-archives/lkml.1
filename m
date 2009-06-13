Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbZFMLYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbZFMLYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 07:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZFMLX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 07:23:59 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:59876 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbZFMLX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 07:23:59 -0400
Message-ID: <4A338C4A.2030406@xs4all.nl>
Date: Sat, 13 Jun 2009 13:23:54 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ACPI: Device needs an ACPI driver
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On my VIA EN12000 with 2.6.29.4 I see in dmesg:

w83627hf: Found W83697HF chip at 0x290
ACPI: I/O resource w83627hf [0x295-0x296] conflicts with ACPI region 
IP__ [0x295-0x296]
ACPI: Device needs an ACPI driver

This is a known issue?

Kind regards,
Udo
