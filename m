Return-Path: <linux-kernel-owner+w=401wt.eu-S933378AbYCFWLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378AbYCFWLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 17:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbYCFWKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 17:10:52 -0500
Received: from khc.piap.pl ([195.187.100.11]:53567 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbYCFWKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 17:10:49 -0500
To: Ville =?iso-8859-2?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
Cc: Zan Lynx <zlynx@acm.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, alan@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] pata: "I do not think it means, what you think it means."
References: <200803042316.m24NGI7k002489@imap1.linux-foundation.org>
	<20080304173058.7679b7c8.akpm@linux-foundation.org>
	<20080305115610.397b3ea3@the-village.bc.nu>
	<200803051421.14167.bzolnier@gmail.com>
	<m3ir015du5.fsf@maximus.localdomain>
	<58cb370e0803050846t7dbd65d6ocfec7ca5e93aa6db@mail.gmail.com>
	<m3ejap5cvz.fsf@maximus.localdomain>
	<58cb370e0803050922p7695771cq393120ed5906efb7@mail.gmail.com>
	<1204742033.6408.37.camel@localhost>
	<m37iggbpqu.fsf@maximus.localdomain> <20080306111304.GK531@sci.fi>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 06 Mar 2008 23:10:46 +0100
In-Reply-To: <20080306111304.GK531@sci.fi> ("Ville =?iso-8859-2?Q?Syrj=E4l?=
 =?iso-8859-2?Q?=E4=22's?= message of "Thu\, 6 Mar 2008 13\:13\:04 +0200")
Message-ID: <m3ablbqza1.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ville Syrjälä <syrjala@sci.fi> writes:

> AFAIK there were basically two series of deathstars. The original
> DTLA<something> and the more recent IC35<something>.

Said friendly distributor recognizes only one deathstar line.
Personally I lost only two such drives, 45 GB I think. My only IC35
(still) produces some strange noises but it was like this from the
beginning and I guess it's normal. IC25 (?, 2.5") still working, too -
noises are a bit different than on IC35.

> Proper cooling and firmware upgrade usually fixed the deathstarness on
> both series.

Nope, DTLAs were not field-fixable, I think it was some problem with
drive electronics. Anyway replacements from IBM were dying the same
death, firmware upgrades or not, brand new or repaired, temperature or
not.

Perhaps there were other problems with them (switching while writing
to medium IIRC) - a different story.
-- 
Krzysztof Halasa
