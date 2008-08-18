Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbYHRUaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbYHRUaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYHRU3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:29:52 -0400
Received: from isilmar.linta.de ([213.133.102.198]:35686 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753521AbYHRU3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:29:51 -0400
Date: Mon, 18 Aug 2008 22:29:50 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: andi@lisas.de, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       johnstul@us.ibm.com, hirofumi@mail.parknet.co.jp,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, stable@kernel.org
Subject: Re: [git pull?] clocksource: ACPI pmtmr bugfixes [Was: Re: ACPI PM-Timer on K6-3 SiS5591: Houston...]
Message-ID: <20080818202950.GA582@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Andrew Morton <akpm@linux-foundation.org>, andi@lisas.de,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	johnstul@us.ibm.com, hirofumi@mail.parknet.co.jp,
	alan@lxorguk.ukuu.org.uk, arjan@infradead.org, stable@kernel.org
References: <20080818200017.GA11247@rhlx01.hs-esslingen.de> <20080810101730.GA10024@rhlx01.hs-esslingen.de> <20080810162920.GA9860@comet.dominikbrodowski.net> <20080810190759.GA1879@rhlx01.hs-esslingen.de> <20080818190325.GA12581@comet.dominikbrodowski.net> <20080818121924.6b61f7af.akpm@linux-foundation.org> <20080818193517.GA22097@isilmar.linta.de> <20080818124755.162f24d1.akpm@linux-foundation.org> <20080818200916.GA18209@comet.dominikbrodowski.net> <20080818132546.0dfcbf77.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818132546.0dfcbf77.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 01:25:46PM -0700, Andrew Morton wrote:
> OK, thanks.  I tagged these as
> 
> Cc: <stable@kernel.org>         [2.6.26.x, 2.6.25.x but not immediately]
> 
> which is a bit rubbery.  What do you think are the criteria for
> deciding when these are ready for the backports?  Something like "after
> 2.6.28-rc1 if nothing blew up"?

That sounds perfectly reasonable.

Best,
	Dominik
