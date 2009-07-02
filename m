Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbZGBNbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbZGBNbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZGBNbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:31:16 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:43660 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752534AbZGBNbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:31:15 -0400
Date: Thu, 2 Jul 2009 09:31:04 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: yakui <yakui.zhao@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: + memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
 added to -mm tree
In-Reply-To: <20090702144415.8B21.E1E9C6FF@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907020929060.32407@gentwo.org>
References: <1246497073.18688.28.camel@localhost.localdomain> <20090702102208.ff480a2d.kamezawa.hiroyu@jp.fujitsu.com> <20090702144415.8B21.E1E9C6FF@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009, Yasunori Goto wrote:

> However, I don't enough time for memory hotplug now,
> and they are just redundant functions now.
> If someone create new allocator (and unifying bootmem allocator),
> I'm very glad. :-)

"Senior"ities all around.... A move like that would require serious
commitment of time. None of us older developers can take that on it
seems.

Do we need to accept that the zone and page metadata are living on another
node?


