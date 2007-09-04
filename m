Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbXIDLqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbXIDLqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 07:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbXIDLpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 07:45:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:57471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbXIDLpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 07:45:53 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: colin.michael@o2online.de
Subject: Re: [patch] enable userspace cpu core voltage control with acpi-cpufreq
Date: Tue, 4 Sep 2007 07:49:37 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernrel.org,
       cpufreq@www.linux.org.uk
References: <200709021441.l82EfWCe022642@mail.mc.o2online.de>
In-Reply-To: <200709021441.l82EfWCe022642@mail.mc.o2online.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709040749.38319.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 September 2007 10:41, colin.michael@o2online.de wrote:

> Hello, 
> i want to make a patch known that provides a userspace interface to control the core voltage of a computer processor(s).
> 
> Some notes about:
> =============================================================
> The current version patches acpi-cpufreq.
> An older version patched speedstep-centrino and also adds additional built-in frequency/voltage tables to the Linux kernel 
> for some Pentium-M CPU models.
> This is particularly usefull for laptops with broken ACPI that can't use the speedstep-centrino cpufreq driver at all.
...
> Project located at: https://www.dedigentoo.org/trac/linux-phc/

Please point me to the unfixed bug reports against Linux/ACPI
that justify the existence of linux-phc and I promise to
do my best to fix them.  If they do not exist today,
then please file them.

I believe that linux-phc is alarmingly dangerous code
and I'm willing to invest my time to make it unnecessary.

thanks,
-Len
