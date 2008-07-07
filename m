Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYGGRAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYGGRAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYGGRAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:00:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52042 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbYGGRAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:00:20 -0400
Date: Mon, 7 Jul 2008 18:06:58 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Altobelli, David" <david.altobelli@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-ID: <20080707160658.GB1794@elf.ucw.cz>
References: <20080623160052.GA7616@ldl.fc.hp.com> <20080627191458.GA10872@ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> A driver for the HP iLO/iLO2 management processor, which allows
> >> userspace programs to query the management processor.  Programs can
> >> open a channel to the device (/dev/hpilo/dXccbN), and use this to
> >> send/receive queries.
> >
> > What kind of queries? Is there documentation somewhere?
> 
> Generally, it can get data out of the management processor - things
> like basic iLO configuration (users, nic, etc), handle SNMP traffic,
> flashing iLO, and some others.
> 
> Unfortunately, there isn't yet any available documenation.

Ok, I guess we should have documentation "what does it do" and "what
protocol does it speak" before we can think about merging.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
