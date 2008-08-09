Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486AbYHIMSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbYHIMSr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 08:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbYHIMSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 08:18:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:52486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYHIMSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 08:18:38 -0400
From: Andreas Schwab <schwab@suse.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain>
	<20080808172629.232bed01@lxorguk.ukuu.org.uk>
	<njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com>
	<m3sktfw1v5.fsf@maximus.localdomain>
	<alpine.LFD.1.10.0808081911080.3254@localhost.localdomain>
	<20080809103331.1d475d5c@lxorguk.ukuu.org.uk>
	<m3zlnm75u1.fsf@maximus.localdomain>
X-Yow: If I pull this SWITCH I'll be RITA HAYWORTH!!  Or a SCIENTOLOGIST!
Date: Sat, 09 Aug 2008 14:18:36 +0200
In-Reply-To: <m3zlnm75u1.fsf@maximus.localdomain> (Krzysztof Halasa's message
	of "Sat, 09 Aug 2008 14:04:06 +0200")
Message-ID: <jeej4ywfdv.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:

> +config ATA_SATA
> +	bool "Serial ATA (SATA) support"
> +	depends on ATA
> +	help
> +	  Say Y here if you want support for Parallel ATA devices.

s/Parallel/Serial/

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
