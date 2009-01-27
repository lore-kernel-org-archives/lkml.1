Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZA0IV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZA0IV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZA0IVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:21:20 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44017 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbZA0IVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:21:19 -0500
Message-ID: <497EC23A.7050408@jp.fujitsu.com>
Date: Tue, 27 Jan 2009 17:13:46 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com
Subject: [PATCH 0/3] fix debug message of LOCAL APIC calibration
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are some minor fix patches for LOCAL APIC calibration.

	[PATCH 1/3] fix debug message of CPU clock speed
	[PATCH 2/3] unify PM-Timer messages
	[PATCH 3/3] fix typo "ACPI_PM_OVRRUN" -> "ACPI_PM_OVERRUN"

For more details, please refer to the header of each patch.

Thanks,
Yasuaki Ishimatsu
