Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbYGDG5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbYGDG5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 02:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYGDG51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 02:57:27 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:61339 "EHLO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYGDG51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 02:57:27 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-13.tower-29.messagelabs.com!1215154646!18038111!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Fri, 4 Jul 2008 08:57:22 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Oliver Neukum <oliver@neukum.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: alphabetic ordering of MAINTAINERS
Message-ID: <20080704065722.GA22420@digi.com>
References: <20080704063455.GA13999@digi.com> <200807040852.27809.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807040852.27809.oliver@neukum.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 04 Jul 2008 06:57:22.0504 (UTC) FILETIME=[35615C80:01C8DDA3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oliver,

Oliver Neukum wrote:
> Am Freitag 04 Juli 2008 08:34:55 schrieb Uwe Kleine-König:
> > Hello,
> >
> > I wanted to add an entry to MAINTAINERS and while doing it I saw that in
> > the corresponding region the alphabetic ordering is broken.  Then I
> > inteded to fix that up for a trivial patch.  Next was to check the rest
> > of the file and there are so much misorderings that it's not sensible to
> > choose the trivial path anymore as there are currently 114 entries out
> > of order[1].
> 
> What good does alphabetic ordering? You'll grep it anyway.
This is fine for me, too.  Then I suggest to remove the section

	Note: For the hard of thinking, this list is meant to remain in alphabetical
	order. If you could add yourselves to it in alphabetical order that would be
	so much easier [Ed]

.  That's why I posted before spending time on writing a clever script.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
