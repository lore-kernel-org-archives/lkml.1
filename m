Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbZBMHql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbZBMHql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 02:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZBMHqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 02:46:33 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:53304 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbZBMHqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 02:46:32 -0500
Message-ID: <49952552.6040000@msgid.tls.msk.ru>
Date: Fri, 13 Feb 2009 10:46:26 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.27.17
References: <20090213013157.GA14377@kroah.com>
In-Reply-To: <20090213013157.GA14377@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Here's the announcement of the 2.6.27.17 kernel.
> 
> It reverts one patch in the 2.6.27.16 kernel release, which caused an
> instant oops if you happened to have a laptop with a docking station.
> Many thanks to David Engel for pointing out the problem.

> Greg Kroah-Hartman (2):
>       Revert "ACPI: dock: Don't eval _STA on every show_docked sysfs read"
>       Linux 2.6.27.17

I wonder if the same should be done with 2.6.28.5...

/mjt
