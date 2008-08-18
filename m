Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYHRUMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYHRUMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYHRUL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:11:27 -0400
Received: from isilmar.linta.de ([213.133.102.198]:60658 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752727AbYHRULZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:11:25 -0400
Date: Mon, 18 Aug 2008 22:09:16 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Andrew Morton <akpm@linux-foundation.org>, Andreas Mohr <andi@lisas.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       johnstul@us.ibm.com, hirofumi@mail.parknet.co.jp,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org
Subject: Re: [git pull?] clocksource: ACPI pmtmr bugfixes [Was: Re: ACPI
	PM-Timer on K6-3 SiS5591: Houston...]
Message-ID: <20080818200916.GA18209@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, johnstul@us.ibm.com,
	hirofumi@mail.parknet.co.jp, alan@lxorguk.ukuu.org.uk,
	arjan@infradead.org
References: <20080818121924.6b61f7af.akpm@linux-foundation.org> <20080818193517.GA22097@isilmar.linta.de> <20080818200017.GA11247@rhlx01.hs-esslingen.de> <20080810101730.GA10024@rhlx01.hs-esslingen.de> <20080810162920.GA9860@comet.dominikbrodowski.net> <20080810190759.GA1879@rhlx01.hs-esslingen.de> <20080818190325.GA12581@comet.dominikbrodowski.net> <20080818121924.6b61f7af.akpm@linux-foundation.org> <20080818193517.GA22097@isilmar.linta.de> <20080818124755.162f24d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818200017.GA11247@rhlx01.hs-esslingen.de> <20080818124755.162f24d1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Could I trouble you to resend them as plain-old-patches, with full
> changelogs along with your thoughts about the suitablity for
> 2.6.2[5678].x please?

patches will be sent as replies to this message. Thanks for taking care of
this; I should have written more meaningful texts. Also, I failed to
remember the second patch hasn't been tested yet ..

On Mon, Aug 18, 2008 at 10:00:17PM +0200, Andreas Mohr wrote:
> I wanted to test your 2nd patch (improved init), but was unable to do so
> (currently too busy due to large changes, plus distance to production system,
> downtime NOT appreciated ;).

.. but still I think this is stuff for 2.6.27; not (yet) suitable for 2.6.26
and 2.6.25 based on the -stable rules.

Best,
	Dominik
