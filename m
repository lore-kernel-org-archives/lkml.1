Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbZKJPxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbZKJPxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbZKJPw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:52:59 -0500
Received: from poutre.nerim.net ([62.4.16.124]:58323 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796AbZKJPw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:52:59 -0500
Date: Tue, 10 Nov 2009 16:53:00 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] lcd: Fix wrong sizeof
Message-ID: <20091110165300.4670f5a5@hyperion.delvare>
In-Reply-To: <20091015115937.6ffc87ab@hyperion.delvare>
References: <20091002112818.54428c49@hyperion.delvare>
	<1254589309.19472.6.camel@ted>
	<20091015115937.6ffc87ab@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 11:59:37 +0200, Jean Delvare wrote:
> On Sat, 03 Oct 2009 18:01:49 +0100, Richard Purdie wrote:
> > On Fri, 2009-10-02 at 11:28 +0200, Jean Delvare wrote:
> > > Which is why I have always preferred sizeof(struct foo) over
> > > sizeof(var).
> > > 
> > > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > > Cc: Richard Purdie <rpurdie@rpsys.net>
> > > ---
> > > Stable team, this one applies to 2.6.31, 2.6.30 and 2.6.27.
> > 
> > Queued in the backlight tree. I'll wait to see if any other fixes appear
> > for backlights send to Linus in a few days.
> 
> Please don't wait too much before sending this for to Linus.

Richard, I still don't see this fix upstream? Would be nice to have it
in 2.6.32.

Thanks,
-- 
Jean Delvare
