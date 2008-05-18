Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYERXGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYERXGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 19:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYERXGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 19:06:38 -0400
Received: from mail.tuxonice.net ([67.207.135.122]:39484 "EHLO
	mail.tuxonice.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYERXGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 19:06:37 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [Bug #10606] 2.6.26-rc1 regression: ACPI fails to load SDT. -
	Dell M1530
From: Nigel Cunningham <nigel@suspend2.net>
Reply-To: nigel@suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <7wuznNhcUqC.A.8BC.KuBMIB@albercik>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.8BC.KuBMIB@albercik>
Content-Type: text/plain
Date: Mon, 19 May 2008 09:08:34 +1000
Message-Id: <1211152114.3037.4.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, 2008-05-18 at 13:13 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10606
> Subject		: 2.6.26-rc1 regression: ACPI fails to load SDT. - Dell M1530
> Submitter	: NIgel Cunningham <nigel@suspend2.net>
> Date		: 2008-05-05 18:11 (14 days old)
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16061&action=view

(cd /usr/src/cg-head; gitk drivers/acpi) after pulling from Linus' tree
doesn't show it yet.

Regards,

Nigel

