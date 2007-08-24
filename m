Return-Path: <linux-kernel-owner+w=401wt.eu-S932739AbXHXHD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbXHXHD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 03:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758780AbXHXHDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 03:03:48 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:38884 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXHXHDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 03:03:47 -0400
Date: Fri, 24 Aug 2007 09:03:21 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: "Bob Picco" <bob.picco@hp.com>
Cc: john stultz <johnstul@us.ibm.com>, "Luck, Tony" <tony.luck@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Picco <bob.picco@hp.com>
Subject: Re: "double" hpet clocksource && hard freeze [bisected]
Message-ID: <20070824090321.40eb913d@localhost>
In-Reply-To: <20070823213849.GA7617@localhost>
References: <20070823222115.122a37ca@localhost>
	<617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com>
	<1187903135.6024.18.camel@localhost.localdomain>
	<20070823213849.GA7617@localhost>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 17:38:49 -0400
"Bob Picco" <bob.picco@hp.com> wrote:

> It appears ACPI discovery failed during driver initialization because
> of:
> hpet_resources: 0xfed00000 is busy

Note: this was always there as far as I can remember.

-- 
	Paolo Ornati
	Linux 2.6.23-rc3-g1a8f4610-dirty on x86_64
