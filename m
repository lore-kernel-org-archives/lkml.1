Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZHDLx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZHDLx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 07:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZHDLx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 07:53:27 -0400
Received: from poutre.nerim.net ([62.4.16.124]:61496 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbZHDLx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 07:53:26 -0400
Date: Tue, 4 Aug 2009 13:53:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: WM831x PMIC hardware monitoring driver
Message-ID: <20090804135321.4784f63d@hyperion.delvare>
In-Reply-To: <20090804113314.GA8601@sortiz.org>
References: <1248702372-29534-12-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1248790260-26211-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20090728162658.0ac35362@hyperion.delvare>
	<20090728145048.GB3013@sirena.org.uk>
	<20090804113314.GA8601@sortiz.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Tue, 4 Aug 2009 13:33:15 +0200, Samuel Ortiz wrote:
> Hi Jean, Mark,
> 
> On Tue, Jul 28, 2009 at 03:50:49PM +0100, Mark Brown wrote:
> > On Tue, Jul 28, 2009 at 04:26:58PM +0200, Jean Delvare wrote:
> > > Acked-by: Jean Delvare <khali@linux-fr.org>
> > >
> > > And as I said before for the wm8350-hwmon driver: I can pick this patch
> > > and push it to Linux in 2.6.32 if you want, but if you want it to take
> > > a different route this is equally fine with me. Just tell me if you
> > > want me to pick it.
> > 
> > I'm more than happy for you to take both - the only reason that I asked
> > you to hold off on the wm8350 patch originally was that I knew I was
> > going to be releasing this driver and there would be collisions with the
> > Kconfig stuff which was due to be released very soon.
> 
> I applied both patches to my for-next branch. Jean, if you prefer them to go
> through your tree, please go ahead and I'll remove them from mine.

This is totally fine with me, thanks for picking them. I've just moved
to a new place and my backlog is big, so I am grateful for any work
others may offload from me :)

-- 
Jean Delvare
