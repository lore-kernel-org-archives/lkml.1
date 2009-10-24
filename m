Return-Path: <linux-kernel-owner+w=401wt.eu-S1751729AbZJXCIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbZJXCIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 22:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZJXCIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 22:08:02 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:34322 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751504AbZJXCIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 22:08:00 -0400
Date: Fri, 23 Oct 2009 21:52:39 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Mel Gorman <mel@csn.ul.ie>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC 
 failures V2
In-Reply-To: <84144f020910220747nba30d8bkc83c2569da79bd7c@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0910232151380.2001@V090114053VZO-1>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <84144f020910220747nba30d8bkc83c2569da79bd7c@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009, Pekka Enberg wrote:

> These are pretty obvious bug fixes and should go to linux-next ASAP IMHO.

Bug fixes go into main not linux-next. Lets make sure these fixes really
work and then merge.

