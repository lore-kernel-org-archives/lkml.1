Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZJ0N1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZJ0N1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZJ0N1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:27:04 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47763 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbZJ0N1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:27:02 -0400
Date: Tue, 27 Oct 2009 13:27:04 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Cc: Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC
	failures V2
Message-ID: <20091027132704.GE8900@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <20091024140207.GA5102@geggus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091024140207.GA5102@geggus.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24, 2009 at 04:02:09PM +0200, Sven Geggus wrote:
> Mel Gorman schrieb am Donnerstag, den 22. Oktober um 16:22 Uhr:
> 
> > Test 1: Verify your problem occurs on 2.6.32-rc5 if you can
> 
> Problem persists. RAID resync in progress :(
> 

What about the rest of the patches, any luck?

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
