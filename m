Return-Path: <linux-kernel-owner+w=401wt.eu-S1763128AbYCFLNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763128AbYCFLNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758367AbYCFLNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:13:08 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37579 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbYCFLNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:13:06 -0500
Date: Thu, 6 Mar 2008 13:13:04 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Zan Lynx <zlynx@acm.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, alan@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] pata: "I do not think it means, what you think it
	means."
Message-ID: <20080306111304.GK531@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Krzysztof Halasa <khc@pm.waw.pl>, Zan Lynx <zlynx@acm.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>, jeff@garzik.org,
	linux-ide@vger.kernel.org, alan@redhat.com,
	linux-kernel@vger.kernel.org
References: <200803042316.m24NGI7k002489@imap1.linux-foundation.org> <20080304173058.7679b7c8.akpm@linux-foundation.org> <20080305115610.397b3ea3@the-village.bc.nu> <200803051421.14167.bzolnier@gmail.com> <m3ir015du5.fsf@maximus.localdomain> <58cb370e0803050846t7dbd65d6ocfec7ca5e93aa6db@mail.gmail.com> <m3ejap5cvz.fsf@maximus.localdomain> <58cb370e0803050922p7695771cq393120ed5906efb7@mail.gmail.com> <1204742033.6408.37.camel@localhost> <m37iggbpqu.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m37iggbpqu.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 02:33:29AM +0100, Krzysztof Halasa wrote:
> Zan Lynx <zlynx@acm.org> writes:
> 
> > In my experience what they needed was proper cooling.  I have a 3ware
> > RAID-5 array of 4 120 GB DeskStar drives still working.
> 
> I think the largest "deathstars" (75GXP?) were 75 GB.

AFAIK there were basically two series of deathstars. The original
DTLA<something> and the more recent IC35<something>. The IC35 series
were bigger (120GB is the most common size I've seen for those).
Proper cooling and firmware upgrade usually fixed the deathstarness on
both series. I still have some of both, not in active use for a year or
two but still working. As a strange coincidence I was just pulling out
some old data from them yesterday.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
