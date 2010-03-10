Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab0CJSi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:38:58 -0500
Received: from mail.perches.com ([173.55.12.10]:1616 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab0CJSi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:38:57 -0500
Subject: Re: Tuxradar patching article and [PATCH]
 scripts/cvt_kernel_style.pl
From: Joe Perches <joe@perches.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       devel <devel@driverdev.osuosl.org>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <4B97E68E.2070205@s5r6.in-berlin.de>
References: <1268177526.1545.62.camel@Joe-Laptop.home>
	 <20100309234152.GA30270@suse.de> <1268179619.1545.95.camel@Joe-Laptop.home>
	 <4B97E68E.2070205@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 10:38:55 -0800
Message-ID: <1268246335.1545.397.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 19:35 +0100, Stefan Richter wrote:
> Joe Perches wrote:
> > It's better to make changes that _actually are_ correct.
> There is no correct and incorrect style.
> There is only
>   - accepted/ not accepted style,
>   - good/ bad style.

I meant to avoid style changes that introduce defects
or don't even compile.

