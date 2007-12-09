Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbXLIT7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbXLIT7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 14:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXLIT7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 14:59:25 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58562 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbXLIT7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 14:59:24 -0500
Date: Sun, 9 Dec 2007 20:59:21 +0100
From: Andreas Mohr <andi@lisas.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071209195921.GA13185@rhlx01.hs-esslingen.de>
References: <200712080340.49546.rjw@sisk.pl> <20071208013631.3147986a.akpm@linux-foundation.org> <20071208101256.GA25807@rhlx01.hs-esslingen.de> <20071208022001.155e0c52.akpm@linux-foundation.org> <20071208105557.GA27646@rhlx01.hs-esslingen.de> <475C0DF1.50108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475C0DF1.50108@gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 10, 2007 at 12:46:57AM +0900, Tejun Heo wrote:
> Please post full kernel boot log and the result of 'lspci -nn'.

Done, on #9530.

Will try some of the promising patches/suggestions now, hopefully this will
show me what's up. Will add further results there.

Andreas Mohr
