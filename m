Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbZCPLnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbZCPLnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbZCPLmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:42:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51440 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbZCPLmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:42:50 -0400
Date: Mon, 16 Mar 2009 12:45:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc5+: cf card no longer detected
Message-ID: <20090316114546.GG2405@elf.ucw.cz>
References: <20090310112330.GE1337@ucw.cz> <200903141944.54036.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903141944.54036.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-03-14 19:44:53, Rafael J. Wysocki wrote:
> On Tuesday 10 March 2009, Pavel Machek wrote:
> > Hi!
> > 
> > compact flash card in pcmcia slot seems to be no longer
> >  detected. Thinkpad x60.
> 
> Where "no longer" means what exactly?  Is 2.6.28 OK?

It turned out to be config error on x60 -- I turned config_ide off by
mistake. But now I hit very similar problem on zaurus; will
investigate it some more.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
