Return-Path: <linux-kernel-owner+w=401wt.eu-S1763487AbXFRRFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763487AbXFRRFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbXFRRFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:05:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50469 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753201AbXFRRFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:05:04 -0400
Date: Mon, 18 Jun 2007 10:05:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/7] Introduce isolate_lru_page_nolock() as a lockless
 version of isolate_lru_page()
In-Reply-To: <20070618092921.7790.78151.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0706181004520.4751@schroedinger.engr.sgi.com>
References: <20070618092821.7790.52015.sendpatchset@skynet.skynet.ie>
 <20070618092921.7790.78151.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Christoph Lameter <clameter@sgi.com>


