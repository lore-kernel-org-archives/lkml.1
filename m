Return-Path: <linux-kernel-owner+w=401wt.eu-S1031555AbXFHSpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031555AbXFHSpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967284AbXFHSph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:45:37 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:5078 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966874AbXFHSpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:45:36 -0400
Date: Fri, 8 Jun 2007 20:45:34 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: Gerhard Mack <gmack@innerfire.net>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: man-pages-2.54 is released
In-Reply-To: <46697DD1.5060307@gmx.net>
Message-ID: <Pine.LNX.4.64.0706082044430.3570@fbirervta.pbzchgretzou.qr>
References: <46695095.2020503@gmx.net> <Pine.LNX.4.64.0706081001210.27398@mtl.rackplans.net>
 <46697DD1.5060307@gmx.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 8 2007 18:03, Michael Kerrisk wrote:
>    Release Philosophy
>    ==================
>
>    If you make sweeping *formatting* changes on a large number of
>    pages, separate them out into their own release that contains
>    minimal *content* changes.  This makes it easier for the people
>    that want to verify content changes independently of the change
>    log.  Yes, some people actually diff each release to see what
>    changed; for example, downstream maintainers, and translators of
>    the man pages (such as the dedicated Alain Portal, in recent
>    times) sometimes like to do this.

I think that sounds more like a repository (svn/git) philosophy
than a release philosophy.


	Jan
-- 
