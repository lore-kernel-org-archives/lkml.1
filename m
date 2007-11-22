Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbXKVSWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbXKVSWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 13:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbXKVSWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 13:22:00 -0500
Received: from mail.suse.de ([195.135.220.2]:59270 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbXKVSV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 13:21:59 -0500
From: Andi Kleen <ak@suse.de>
To: "Arnaldo Carvalho de Melo" <acme@redhat.com>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Date: Thu, 22 Nov 2007 19:17:37 +0100
User-Agent: KMail/1.9.1
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org,
       rusty@rustcorp.com.au
References: <20071122343.446909000@suse.de> <20071122120110.GA17441@ghostprotocols.net>
In-Reply-To: <20071122120110.GA17441@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711221917.38334.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Creating the DCCP and its congestion control infrastructure (CCID)
> module namespaces is now on my TODO list. :-)

My original patchkit had DCCP actually done, but I ran into some problem
while forward porting and disabled it again. But should be reasonably
easy to resurrect.

-Andi
