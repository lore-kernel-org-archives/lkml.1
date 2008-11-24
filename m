Return-Path: <linux-kernel-owner+w=401wt.eu-S1752408AbYKXH0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbYKXH0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 02:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYKXHZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 02:25:58 -0500
Received: from eazy.amigager.de ([213.239.192.238]:39551 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYKXHZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 02:25:57 -0500
Date: Mon, 24 Nov 2008 08:26:10 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [Bug #11982] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081124072610.GA23517@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera> <vyitTh0pP2N.A.BqC.97HKJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vyitTh0pP2N.A.BqC.97HKJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 21:28:17 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).

git log drivers/misc/thinkpad_acpi.c shows no changes since August 1st,
so I thing it's save to assume that the regression still exists.

Regards,
Tino
