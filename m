Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZBOPYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZBOPYU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 10:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZBOPYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 10:24:11 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:29667 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZBOPYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 10:24:10 -0500
Date: Sun, 15 Feb 2009 16:23:59 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Shem Multinymous <multinymous@gmail.com>, Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Frank Seidel <frank@f-seidel.de>
Subject: Re: [PATCH] hwmon/hdaps: Fix bug 7154 inversion of separate axis
Message-ID: <20090215162359.763b3918@hyperion.delvare>
In-Reply-To: <20090215134115.GA21670@srcf.ucam.org>
References: <499569A9.5030202@suse.de>
	<41840b750902141632l5c4bd705m1b528900466a25fd@mail.gmail.com>
	<20090215102707.174e770f@hyperion.delvare>
	<20090215134115.GA21670@srcf.ucam.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Feb 2009 13:41:15 +0000, Matthew Garrett wrote:
> On Sun, Feb 15, 2009 at 10:27:07AM +0100, Jean Delvare wrote:
> > On Sat, 14 Feb 2009 19:32:02 -0500, Shem Multinymous wrote:
> > > See the table at the bottom of the tp_smapi page
> > > (http://www.thinkwiki.org/wiki/Tp_smapi), or hdaps.c inside the
> > > tp_smapi package, for more model-specific information.
> > > It would be nice if you made the interface (constants and their
> > > meaning) the same as in the tp_smapi version of hdaps, which is
> > > already widely deployed and packaged by several distros.
> > 
> > Why is this code not upstream? Ah yeah, I remember now: because it was
> > written by an anonymous developer, which makes the contribution legally
> > dubious. Copying such code into the upstream version of hdaps would be
> > no different, so we cannot do that, sorry.
> 
> You're arguing that sysfs interfaces are copyrightable?

I'm not arguing anything. I'll let you, Shame Multithing and anyone
else with too much spare time argue whatever you want. Me, I have many
more useful things to do.

Thanks but no thanks,
-- 
Jean Delvare
