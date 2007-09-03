Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbXICXCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbXICXCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 19:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbXICXCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 19:02:16 -0400
Received: from ns2.suse.de ([195.135.220.15]:52434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbXICXCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 19:02:15 -0400
To: Stefan Becker <Stefan.Becker@nokia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [pre-2.6.23 REGRESSION] 2.6.23-rc3-git1 crash/stuck on VIA CN700 system
References: <46C9D148.5080505@nokia.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 04 Sep 2007 01:02:14 +0200
In-Reply-To: <46C9D148.5080505@nokia.com>
Message-ID: <p734pibbbex.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Becker <Stefan.Becker@nokia.com> writes:

> while trying to debug a hibernation/rtc_cmos alarm wakeup problem in
> 2.6.22 (or later) I noticed that the latest kernel crashes (or gets
> stuck sometimes) during boot after the message:
> 
> SMP alternatives: switching to UP code
> 
> Every kernel up to 2.6.22.1 works fine on the system.

Does the problem start with 2.6.22.2 or with 2.6.23-rc? 

The first sentence conflicts with the last one.

> I've attached
> the log file taken from the serial console (4 boot attempts with
> different acpi= options) and the .config of the kernel. The kernel is
> from the Fedora 8 development line.

Please report for mainline kernels.

-Andi
