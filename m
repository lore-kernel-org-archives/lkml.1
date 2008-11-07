Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbYKGWqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbYKGWqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 17:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYKGWqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 17:46:09 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:38762 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYKGWqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 17:46:08 -0500
Subject: Re: [patch 2.6.28-rc3-git] regulator: Kconfig works normally
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: broonie@opensource.wolfsonmicro.com, lkml <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <200811071403.54469.david-b@pacbell.net>
References: <200811071403.54469.david-b@pacbell.net>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 22:46:02 +0000
Message-Id: <1226097962.6727.30.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 14:03 -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Fix dependencies in drivers/regulator/Kconfig:  don't show *ANY*
> options unless regulator support is enabled.  Also get rid of all
> the nasty reverse dependencies.  This just switches over to use
> standard Kconfig idioms, making this tree act normally.

Thanks, I got a very similar patch from Takashi a few days ago and
applied to regulator for-linus. I'll do a pull request shortly.

Thanks

Liam 

