Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbXKCGfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbXKCGfb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 02:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbXKCGfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 02:35:23 -0400
Received: from smtp05.mtu.ru ([62.5.255.52]:53322 "EHLO smtp05.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422AbXKCGfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 02:35:22 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [regression] v2.6.24-rc1-497-gb1d08ac: kde battery icon gone
To: Thomas Meyer <thomas@m3y3r.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sat, 03 Nov 2007 09:35:16 +0300
References: <472B5C01.7090508@m3y3r.de>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20071103063520.13EA59AFABF@smtp05.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:

> i just wanted to report this:
> 
> in v2.6.24-rc1-497-gb1d08ac the kde battery icon is no longer displayed.
> 
> with 2.6.23 shows the battery icon.
> 
> current config:
> 
> grep -i acpi .config
> # Power management options (ACPI, APM)
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS is not set

And if you enable it (ACPI_PROCFS)?


