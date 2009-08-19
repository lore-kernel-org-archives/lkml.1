Return-Path: <linux-kernel-owner+w=401wt.eu-S1751445AbZHSJG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbZHSJG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZHSJGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:06:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:42105 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbZHSJGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:06:25 -0400
Date: Wed, 19 Aug 2009 11:06:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH V3 linux-next] treewide: remove unnecessary semicolons
In-Reply-To: <1250619515.25478.19.camel@Joe-Laptop.home>
Message-ID: <alpine.LNX.2.00.0908191105570.25797@wotan.suse.de>
References: <1248472866.3498.79.camel@Joe-Laptop.home>  <alpine.LNX.2.00.0908131155510.25797@wotan.suse.de>  <1250158868.28285.26.camel@Joe-Laptop.home>  <alpine.LNX.2.00.0908181359450.25797@wotan.suse.de> <1250619515.25478.19.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009, Joe Perches wrote:

> > > > > Previous discussion at: http://lkml.org/lkml/2009/6/28/288
> > > > > Signed-off-by: Joe Perches <joe@perches.com>
> > > I could do that or you could "git apply --exclude=drivers/staging/"
> > > Which do you prefer?
> > It doesn't apply any more, could you please refresh, resend, and I will 
> > apply it right away?
> I used git apply --reject --exclude=drivers/staging

OK, applied, let's see how many conflicts we get.

Thanks,

-- 
Jiri Kosina
SUSE Labs
