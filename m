Return-Path: <linux-kernel-owner+w=401wt.eu-S1751094AbXBMVcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751094AbXBMVcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 16:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbXBMVcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 16:32:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43747 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751090AbXBMVcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 16:32:13 -0500
Date: Tue, 13 Feb 2007 21:46:08 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: User tools for March 11
Message-ID: <20070213214608.6e9a66ab@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.61.0702131607590.27065@chaos.analogic.com>
References: <Pine.LNX.4.61.0702131607590.27065@chaos.analogic.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 16:19:59 -0500
"linux-os \(Dick Johnson\)" <linux-os@analogic.com> wrote:

> 
> Hi!
> In the United States, some idiots have decided that the year 2000 scare
> wasn't enough so they changed the start date for daylight savings time
> from the first Sunday in April to the second Sunday in March.
> Does anybody know if there are new tools like `hwclock` and `date`?
> Will new 'C' runtime libraries be necessary as well?

Your vendor should be able to tell you whether the library versions you
have are sufficiently up to date, which apps need restarting and which
apps use their own timezone code and problems (check for example if you
use Java)

It's nothing special, timezone rules change all the time. Be glad the
world is mostly standardising. When I was younger the UK summer time
switches were set in a meeting each year and they were not too worried
about adjusting it a week for Royal Ascot and that kind of thing.

Alan
