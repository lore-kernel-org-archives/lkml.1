Return-Path: <linux-kernel-owner+w=401wt.eu-S932963AbXBTRvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbXBTRvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932965AbXBTRvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:51:48 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:40780 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932963AbXBTRvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:51:48 -0500
Date: Tue, 20 Feb 2007 18:51:37 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: NZG <ngustavson@emacinc.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fwd: GPIO device class driver
Message-ID: <20070220175137.GC29553@pengutronix.de>
References: <200702201054.05474.ngustavson@emacinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200702201054.05474.ngustavson@emacinc.com>
User-Agent: Mutt/1.5.5.1+cvs20040105i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 10:54:05AM -0600, NZG wrote:
> Sent this to the LKML, but forgot to CC you.
> May I see you current work on the GPIO class?
> 
> thank you,
> Nathan Z. Gustavson
> Systems Engineer
> EMAC.Inc -www.emacinc.com
> 
> ----------  Forwarded Message  ----------
> 
> Subject: GPIO device class driver
> Date: Tuesday 20 February 2007 10:40 am
> From: NZG <ngustavson@emacinc.com>
> To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
> 
> I am currently developing support for an ep9xx based SBC and want to export
> it's GPIO through sysfs in a simple and standard way,
> without adding yet another platform specific gpio driver to the kernel.
> 
> As I understand it, a gpio class has already been begun by Robert Schwebel in
> but has not as of yet become part of the mainstream kernel.
> 
> Searching the archives for this yields no results since 2006.
> 
> Can anyone point me to a current patch?
> I'd like to start from there.
> 
> thank you,
> NZG
> -------------------------------------------------------

In the meantime there is activity for a gpio framework in mainline; I
didn't follow the details recently, but David Brownell might be a good
contact.

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

