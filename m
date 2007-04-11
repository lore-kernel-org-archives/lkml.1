Return-Path: <linux-kernel-owner+w=401wt.eu-S1161397AbXDKW75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161397AbXDKW75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161399AbXDKW74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:59:56 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:60528 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161397AbXDKW7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:59:46 -0400
Subject: Re: mconf not removed by make mrproper
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070401211705.GA11077@uranus.ravnborg.org>
References: <1170299149.32500.13.camel@nigel.suspend2.net>
	 <20070401211705.GA11077@uranus.ravnborg.org>
Content-Type: text/plain
Date: Thu, 12 Apr 2007 08:59:44 +1000
Message-Id: <1176332385.7112.17.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, 2007-04-01 at 23:17 +0200, Sam Ravnborg wrote:
> On Thu, Feb 01, 2007 at 02:05:49PM +1100, Nigel Cunningham wrote:
> > Hi.
> > 
> > The scripts/kconfig/mconf target isn't removed by the make mrproper
> > target. I can see a couple of possibilities, but wasn't sure which you'd
> > prefer, so thought I'd just raise the issue.
> > 
> > It's only an issue for me because my patch generation script relies on
> > make mrproper making a properly clean tree.
> 
> Fixed - thanks.
> 
> 	Sam

Works fine here; thanks!

Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>


