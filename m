Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab0CCWFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 17:05:37 -0500
Received: from poutre.nerim.net ([62.4.16.124]:57932 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab0CCWFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 17:05:31 -0500
Date: Wed, 3 Mar 2010 23:05:29 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mike Chan <mike@android.com>
Cc: Dima Zavin <dmitriyz@google.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
Message-ID: <20100303230529.2e7a1a5a@hyperion.delvare>
In-Reply-To: <8bb80c381003031356s4b9fa6abj15e7ca207552ac6d@mail.gmail.com>
References: <4B8C1867.7040201@cam.ac.uk>
	<404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
	<alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
	<20100303184132.GA11471@core.coreip.homeip.net>
	<alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
	<20100303190753.GB11471@core.coreip.homeip.net>
	<404ea8001003031338j34847961jd8a7114bbc45603a@mail.gmail.com>
	<8bb80c381003031356s4b9fa6abj15e7ca207552ac6d@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010 13:56:45 -0800, Mike Chan wrote:
> Slightly off topic here, but with the introduction of an als
> subsystem, wouldn't you want to unify how the kernel export lux
> values? Currently it seems the driver can export whatever they want to
> export, lux or lumen, whatever they want.

Would you mind reading the patches that are being discussed here before
you comment?

Thank you very much,
-- 
Jean Delvare
