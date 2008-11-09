Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYKIOQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYKIOQD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 09:16:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYKIOPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 09:15:53 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:39831 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbYKIOPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 09:15:53 -0500
Date: Sun, 9 Nov 2008 15:15:51 +0100
From: Andreas Mohr <andi@lisas.de>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.28-rc3: regression, thinkpad x60 will not reboot
Message-ID: <20081109141551.GA20019@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

AcerOne A110L, Insyde BIOS, init=/bin/sh on 2.6.27 and 2.6.28-rc3,
Ctrl-Alt-Del works on .27 and hangs on -rc3 (screen dark, full lockup).
So yeah, ACPI reboot seems to be unhealthy ;)

Andreas Mohr
