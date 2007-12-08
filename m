Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbXLHK4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbXLHK4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 05:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbXLHKz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 05:55:59 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59283 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbXLHKz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 05:55:58 -0500
Date: Sat, 8 Dec 2007 11:55:57 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071208105557.GA27646@rhlx01.hs-esslingen.de>
References: <200712080340.49546.rjw@sisk.pl> <20071208013631.3147986a.akpm@linux-foundation.org> <20071208101256.GA25807@rhlx01.hs-esslingen.de> <20071208022001.155e0c52.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208022001.155e0c52.akpm@linux-foundation.org>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Dec 08, 2007 at 02:20:01AM -0800, Andrew Morton wrote:
> > Does this report now win me the lucky draw, pretty please? ;)
> 
> nah, you have to cc the acpi guys to get a prize ;)

Thought so shortly, but missed it.

> Andreas, please do separately report that WOL problem too..

Local setup issue only, at least this one *isn't* a 2.6.24-rc regression. ;)

> Our list just reached 30.

Oh, so this is in fact a separate issue? Wasn't sure, couldn't do
enough analysis of similar cases.

Will test any (already submitted!) suggestions ASAP.

Andreas Mohr
