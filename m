Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbZGUSVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbZGUSVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 14:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbZGUSV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 14:21:29 -0400
Received: from mail.globalsuite.net ([69.46.103.200]:36111 "HELO
	mail.globalsuite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754461AbZGUSV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 14:21:28 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 14:21:18 EDT
X-AuditID: c0a8013c-ab15ebb00000711e-64-4a5fd7ec9ddc
Date: Thu, 16 Jul 2009 21:46:15 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@sony-vgn-z540
To: Alexander Beregalov <a.beregalov@gmail.com>
cc: linux-next <linux-next@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: next: sfi build fails when !CONFIG_ACPI
In-Reply-To: <a4423d670907160148n66760052wbef60e4a2c3c7941@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0907162145140.3531@sony-vgn-z540>
References: <a4423d670907160148n66760052wbef60e4a2c3c7941@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: AAAAARAANew=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/sfi/sfi_core.c: In function 'sfi_init':
> drivers/sfi/sfi_core.c:346: error: 'acpi_disabled' undeclared (first
> use in this function)
> drivers/sfi/sfi_core.c:346: error: (Each undeclared identifier is
> reported only once
> drivers/sfi/sfi_core.c:346: error: for each function it appears in.)
> 
> 
> $ grep ACPI .config
> # Power management and ACPI options

It builds for me.
Please send me the complete failing .config

thanks,
Len Brown, Intel Open Source Technology Center
