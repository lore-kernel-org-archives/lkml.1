Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbZBQAJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbZBQAJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 19:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbZBQAJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 19:09:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50962 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZBQAJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 19:09:44 -0500
Date: Tue, 17 Feb 2009 09:08:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, David CHAMPELOVIER <david@champelovier.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix vmaccnt at fork (Was Re: "heuristic overcommit" and
 fork())
Message-Id: <20090217090829.4adf3e70.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090216143231.GB16153@csn.ul.ie>
References: <ED3886372DB5491AAA799709DBA78F6F@david>
	<20090213103655.3a0ea204.kamezawa.hiroyu@jp.fujitsu.com>
	<20090216143231.GB16153@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 14:32:32 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> >  #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
> >  
> >  #if !defined(CONFIG_ARCH_POPULATES_NODE_MAP) && \
> > 
> > 
> 
> NAK.
> 
Ok, I'm wrong. thanks.

-Kame

