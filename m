Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab0CJAeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:34:21 -0500
Received: from mail.perches.com ([173.55.12.10]:1577 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab0CJAeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:34:19 -0500
Subject: Re: Tuxradar patching article and [PATCH]
 scripts/cvt_kernel_style.pl
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, devel <devel@driverdev.osuosl.org>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20100310001638.GA10960@suse.de>
References: <1268177526.1545.62.camel@Joe-Laptop.home>
	 <20100309234152.GA30270@suse.de> <1268179619.1545.95.camel@Joe-Laptop.home>
	 <20100310001638.GA10960@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 16:34:17 -0800
Message-ID: <1268181257.1545.107.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 15:41 -0800, Greg KH wrote:
> I _really_ dislike automatic source conversions by a tool and do not
> recommend doing that at all.
 
On Tue, 2010-03-09 at 16:16 -0800, Greg KH wrote:
> > You take automatic conversions from tools like coccinelle all
> > the time.
> Those are sane, as they are tiny and obvious :)

You contradict yourself.

> It's the huge "reformat the whole file with indent" type stuff
> that I object to.

Which is sensible and not what you lead with.

Any conversion done an automatic tool should be limited to
a specific type of change and should not be done wholesale.

Scripts like what I posted are easy to limit to specific
types of conversion.  Tools like Lindent are not.

cheers, Joe

