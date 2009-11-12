Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZKLQzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZKLQzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZKLQzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:55:12 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:42155 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZKLQzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:55:11 -0500
Date: Thu, 12 Nov 2009 08:40:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Paul Fertser <fercerpav@gmail.com>, Ben Dooks <ben@simtec.co.uk>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 3/6] gta02: set pcf50633 charger_reference_current_ma
Message-ID: <20091112074059.GB11365@elf.ucw.cz>
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com>
 <1257369899-325-2-git-send-email-fercerpav@gmail.com>
 <1257369899-325-3-git-send-email-fercerpav@gmail.com>
 <20091111134844.GB22476@home.pavel.comp>
 <20091111153143.GA1610@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111153143.GA1610@oksana.dev.rtsoft.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-11-11 18:31:43, Anton Vorontsov wrote:
> On Wed, Nov 11, 2009 at 04:48:44PM +0300, Paul Fertser wrote:
> > Hi,
> > 
> > Ben, please give us an advice on how to proceed with this rather
> > trivial patch. Anton doesn't merge the other patches from this series
> > because we do not know via which tree to merge this particular patch.
> 
> Paul, I'll just merge the whole patch set but skip this particular
> patch.

Feel free to merge that patch, too. It is clearly related to the
other stuff, and Russell being totally unresponsive should not be
reason to block patches.

He is the maintainer, he was cc-ed, and at this point it is quite
clear that he does not care.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
