Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYGZCVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYGZCVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 22:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYGZCVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 22:21:33 -0400
Received: from tau.jukie.net ([216.239.93.128]:56467 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbYGZCVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 22:21:33 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2008 22:21:32 EDT
Date: Fri, 25 Jul 2008 22:13:24 -0400
From: Bart Trojanowski <bart@jukie.net>
To: Jack Howarth <howarth@bromo.msbb.uc.edu>, linux-kernel@vger.kernel.org
Subject: Re: git snapshots (Was: Re: merging branches remotely with git?)
Message-ID: <20080726021324.GA30789@jukie.net>
References: <20080725112231.GA28411@digi.com> <1216986122.7098.36.camel@muff> <20080725234443.GA10681@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725234443.GA10681@bromo.msbb.uc.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jack Howarth <howarth@bromo.msbb.uc.edu> [080725 19:45]:
>    Does anyone know what kernel sources the my-wireless-testing git
> is based on? If it is based on the stock 2.6.26 release with only
> wireless specific patches, perhaps I could just diff it against 
> 2.6.26 to extract the patches needed for ath9k support? I would
> rather stick to the stable git releases of 2.6.26 for now with
> the minimum patches applied to get ath9k working on my MacBook Pro.

Jack,

you can run 'git describe' to get a description of how the HEAD relates
to the most resent tag.  In this case the output of
'v2.6.26-rc9-14207-ga520bdb' suggests that this my-wireless-testing's
based on v2.6.26-rc9, or shortly there after.

-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
