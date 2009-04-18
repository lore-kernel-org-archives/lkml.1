Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbZDRFrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbZDRFrt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 01:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZDRFrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 01:47:41 -0400
Received: from mx38.mail.ru ([94.100.176.52]:64365 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbZDRFrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 01:47:40 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH 1/2] toshiba-acpi: Add support for hotkey notifications
To: Len Brown <lenb@kernel.org>, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Sat, 18 Apr 2009 09:47:25 +0400
References: <20090331214501.GC29489@srcf.ucam.org> <alpine.LFD.2.00.0904180000330.30751@localhost.localdomain>
User-Agent: KNode/0.99.01
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Lv3Or-000CHe-00.arvidjaar-mail-ru@mx38.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:

> drivers/platform/x86/toshiba_acpi.c:854: warning: passing argument 3 of
> ‘acpi_install_notify_handler’ from incompatible pointer type
> drivers/platform/x86/toshiba_acpi.c:903: warning: passing argument 3 of
> ‘acpi_remove_notify_handler’ from incompatible pointer type

Patch was here:

http://marc.info/?l=linux-acpi&m=123636477425172&w=2
