Return-Path: <linux-kernel-owner+w=401wt.eu-S965815AbZLHTKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965815AbZLHTKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965793AbZLHTKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:10:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38532 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965789AbZLHTKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:10:12 -0500
Date: Tue, 8 Dec 2009 19:10:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update file patterns for WOLFSON
	MICROELECTRONICS PMIC DRIVERS
Message-ID: <20091208191018.GB2590@opensource.wolfsonmicro.com>
References: <1260298117.27677.61.camel@Joe-Laptop.home> <20091208185132.GA2590@opensource.wolfsonmicro.com> <1260298457.27677.63.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260298457.27677.63.camel@Joe-Laptop.home>
X-Cookie: You will inherit millions of dollars.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 10:54:17AM -0800, Joe Perches wrote:
> On Tue, 2009-12-08 at 18:51 +0000, Mark Brown wrote:

> > Why not Documentation/hwmon/wm831x?

> Beats me, it's your entry, add all the appropriate ones.

It wasn't clear why you were adding one and not the other.

> Maybe:

> F:	Documentation/hwmon/wm8*

That is possibly too general - the names are already very close to the
Winbond ones as it is, wm83?? might be safer.
