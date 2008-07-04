Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbYGDOCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbYGDOCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbYGDOCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:02:46 -0400
Received: from mail51.messagelabs.com ([216.82.244.179]:45711 "EHLO
	mail51.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbYGDOCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:02:46 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-13.tower-51.messagelabs.com!1215180164!5045658!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Fri, 4 Jul 2008 16:02:40 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Paul Mundt <lethal@linux-sh.org>, Oliver Neukum <oliver@neukum.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: alphabetic ordering of MAINTAINERS
Message-ID: <20080704140240.GB32700@digi.com>
References: <20080704063455.GA13999@digi.com> <200807040852.27809.oliver@neukum.org> <20080704065722.GA22420@digi.com> <20080704085910.GA9671@linux-sh.org> <20080704091023.GA9783@digi.com> <20080704130737.525507a5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080704130737.525507a5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 04 Jul 2008 14:02:40.0919 (UTC) FILETIME=[9F8A7A70:01C8DDDE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Alan Cox wrote:
> > > I always interpreted this to mean that the _entries_ are alphabetically
> > > sorted, not the maintainers under each entry. IIRC, Alan has already
> > > cleaned up most of the ordering of the entries through recent patches.
> > That's how I interpret it, too. :-)
> >
> > Look at
> >
> >       http://www.modarm9.com/git/people/ukleinek/linux-2.6.git?a=commitdiff;h=62110fbc73a9d3a4c7d39706b648b554b517f154#patch1
> 
> 
> Nice but you've chopped off the Linus entry at the end. It would be good
> to get the others fixed and the script in the scripts dir
fixed and branch updated.

> BTW - I suspect your script needs to force a locale.
Right.  At least if it gets a wider audience.  Done and Thanks.

Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
