Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbXEQVMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbXEQVMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbXEQVMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:12:32 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:36115 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754740AbXEQVMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:12:32 -0400
Date: Thu, 17 May 2007 23:12:29 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Rob Landley <rob@landley.net>
Cc: LKML <linux-kernel@vger.kernel.org>, jdike@karaya.com
Subject: Re: UML doesn't compile in 2.6.21
Message-ID: <20070517211229.GP12319@pengutronix.de>
References: <20070516224938.GN12319@pengutronix.de> <200705162111.19123.rob@landley.net> <20070517210538.GO12319@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070517210538.GO12319@pengutronix.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 11:05:38PM +0200, Robert Schwebel wrote:
> So it must be something with my configuration. I've tried to build a
> minimized configuration, see below. You can trigger the bug here by
> changing "Enable loadable module support.

update: it can also be triggered by switching off the "embedded" option.

Robert 
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

