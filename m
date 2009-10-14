Return-Path: <linux-kernel-owner+w=401wt.eu-S934811AbZJNQOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934811AbZJNQOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933402AbZJNQOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:14:41 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:58332 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932098AbZJNQOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:14:40 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Wed, 14 Oct 2009 18:13:58 +0200
User-Agent: KMail/1.9.9
Cc: David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910141510.11059.elendil@planet.nl> <20091014154026.GC5027@csn.ul.ie>
In-Reply-To: <20091014154026.GC5027@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910141814.02744.elendil@planet.nl>
X-OriginalArrivalTime: 14 Oct 2009 16:14:03.0208 (UTC) FILETIME=[58A99480:01CA4CE9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009, Mel Gorman wrote:
> You highlighted the first akpm merge so lets look closer at that as I
> don't think there is anything more I can do with the wireless driver
> other than the suggestions made already.

Thanks a lot for that analysis Mel. I'll see if I can come up with 
additional data based of the info you provide here.
