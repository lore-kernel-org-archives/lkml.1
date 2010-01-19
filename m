Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750Ab0ASVM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab0ASVM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738Ab0ASVM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:12:58 -0500
Received: from mail.perches.com ([173.55.12.10]:1285 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731Ab0ASVM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:12:57 -0500
Subject: Re: [PATCH] watchdogs: constify struct watchdog_info
From: Joe Perches <joe@perches.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20100119210220.GD3804@infomag.iguana.be>
References: <1263865537.18117.23.camel@Joe-Laptop.home>
	 <20100119085613.GA3804@infomag.iguana.be>
	 <1263932897.18117.40.camel@Joe-Laptop.home>
	 <20100119210220.GD3804@infomag.iguana.be>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 13:12:55 -0800
Message-ID: <1263935575.18117.46.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 22:02 +0100, Wim Van Sebroeck wrote:
> > I did send you awhile ago a patch series
> > to convert to pr_fmt() and pr_<level>.
> > http://lkml.org/lkml/2009/7/21/5
> > Do you still eventually want those?
> I didn't forget them and want them definitely in the future.

OK then.  No worries, no rush.

> But first I would like to put my efforts in completing the
> generic watchdog setup (before Alan Cox turns grey and more
> then 100 years old :-) ).

One down, one to go?

cheers, Joe

