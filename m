Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbYKXIDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbYKXIDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 03:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYKXIDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 03:03:37 -0500
Received: from eazy.amigager.de ([213.239.192.238]:46718 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYKXIDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 03:03:36 -0500
Date: Mon, 24 Nov 2008 09:03:35 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12038] Suspend regression in stable kernel 2.6.27.4 on
	Mac mini Core Duo
Message-ID: <20081124080334.GA4598@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera> <vyitTh0pP2N.A.nJC.c7HKJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vyitTh0pP2N.A.nJC.c7HKJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 21:28:19 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).

Hi,

2.6.28-rc6 (or more precisely:
ed313489badef16d700f5a3be50e8fd8f8294bc8) still hangs my Mac after
resume, and git log drivers/acpi/sleep/main.c shows no relevant commits.

Regards,
Tino
