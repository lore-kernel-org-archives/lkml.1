Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbZI1Cp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbZI1Cp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 22:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZI1Cp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 22:45:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:46893 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbZI1Cpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 22:45:54 -0400
Date: Mon, 28 Sep 2009 05:45:41 +0300
From: Amit Kucheria <amit.kucheria@canonical.com>
To: vimal singh <vimal.newwork@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, vimal singh <vimalsingh@ti.com>,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mfd: restoring twl4030 power-off and power-button
 capabilities
Message-ID: <20090928024541.GL32041@smtp.gmail.com>
Mail-Followup-To: vimal singh <vimal.newwork@gmail.com>,
	Tony Lindgren <tony@atomide.com>, vimal singh <vimalsingh@ti.com>,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
References: <52241.192.168.10.89.1251990701.squirrel@dbdmail.itg.ti.com>
 <ce9ab5790909251949s71083c3brd625d36653387cc8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce9ab5790909251949s71083c3brd625d36653387cc8@mail.gmail.com>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vimal,

These patches should also be cc'ed to Samuel Ortiz who is the maintainer of
the MFD subsystem where the twl4030 driver resides. It should go upstream
through his tree.

/Amit

On 09 Sep 25, vimal singh wrote:
> Hi Tony,
> 
> Since there are no comments on these patches, can these go upstream?
> Or, is there something to fix?
> 
> --vimal
> 
> On Thu, Sep 3, 2009 at 8:11 AM, vimal singh <vimalsingh@ti.com> wrote:
> > This patch series restores the TWL Power-button and Power-off capabilities.
> > Which were removed in "REMOVE OMAP LEGACY CODE" patches.
> >
> > Patches are compile tested only.
> >
> > [PATCH 1/2]: twl4030: register twl4030-pwrbuttonas a child of twl4030-core.c
> > [PATCH 2/2]: twl4030: initialization of pm_power_off in twl4030-core.c
> >
> > Both patches are based on Felipe Balbi's patches posted earlier.
> > http://lkml.org/lkml/2009/2/28/88
> > http://markmail.org/message/ts4if3553qnauket
> >
> > --
> > Vimal
> >
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
-------------------------------------------------------------------------
Amit Kucheria,				 Kernel Developer, Verdurent
-------------------------------------------------------------------------
