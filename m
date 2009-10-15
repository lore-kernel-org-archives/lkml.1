Return-Path: <linux-kernel-owner+w=401wt.eu-S1761374AbZJOKA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761374AbZJOKA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 06:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbZJOKA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 06:00:26 -0400
Received: from poutre.nerim.net ([62.4.16.124]:63830 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029AbZJOKA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 06:00:26 -0400
Date: Thu, 15 Oct 2009 11:59:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] lcd: Fix wrong sizeof
Message-ID: <20091015115937.6ffc87ab@hyperion.delvare>
In-Reply-To: <1254589309.19472.6.camel@ted>
References: <20091002112818.54428c49@hyperion.delvare>
	<1254589309.19472.6.camel@ted>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Oct 2009 18:01:49 +0100, Richard Purdie wrote:
> On Fri, 2009-10-02 at 11:28 +0200, Jean Delvare wrote:
> > Which is why I have always preferred sizeof(struct foo) over
> > sizeof(var).
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Richard Purdie <rpurdie@rpsys.net>
> > ---
> > Stable team, this one applies to 2.6.31, 2.6.30 and 2.6.27.
> 
> Queued in the backlight tree. I'll wait to see if any other fixes appear
> for backlights send to Linus in a few days.

Please don't wait too much before sending this for to Linus.

-- 
Jean Delvare
