Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZA1Dxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZA1Dxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZA1Dx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:53:28 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42296 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbZA1Dx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:53:28 -0500
Message-ID: <497FD4F3.3080006@jp.fujitsu.com>
Date: Wed, 28 Jan 2009 12:45:55 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH take2 0/3] fix debug message of LOCAL APIC calibration
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are some minor fix patches for LOCAL APIC calibration.
I merged Ingo's comment (http://lkml.org/lkml/2009/1/27/142)
into [PATCH take2 1/3].

	[PATCH take2 1/3] fix debug message of CPU clock speed
	[PATCH take2 2/3] unify PM-Timer messages
	[PATCH take2 3/3] fix typo "ACPI_PM_OVRRUN" -> "ACPI_PM_OVERRUN"

For more details, please refer to the header of each patch.

Thanks,
Yasuaki Ishimatsu
