Return-Path: <linux-kernel-owner+w=401wt.eu-S1161449AbXBGWEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161449AbXBGWEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422778AbXBGWEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:04:36 -0500
Received: from [212.12.190.117] ([212.12.190.117]:32958 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161449AbXBGWEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:04:35 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21
Date: Thu, 8 Feb 2007 00:55:33 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702080055.33939.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> ACPICA Core version 2070126 simplifies the ACPI table manager
> code by consolidating multiple table definitions into one.
> It also saves memory by mapping the tables where the BIOS provides them
> rather than copying them into the kernel.

Thanks for the update, but does it fix the ISA VGA STR-regression in 2.6.20?

Also, is there some dependency that requires a display card to be present for 
STR to work?


Thanks!

--
Al

