Return-Path: <linux-kernel-owner+w=401wt.eu-S1760129AbXFSQvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129AbXFSQvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbXFSQu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:50:59 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:40729 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbXFSQu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:50:59 -0400
Date: Tue, 19 Jun 2007 17:50:57 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 7/7] Compact memory directly by a process when a high-order allocation fails
Message-ID: <20070619165057.GF17109@skynet.ie>
References: <20070618092821.7790.52015.sendpatchset@skynet.skynet.ie> <20070618093042.7790.30669.sendpatchset@skynet.skynet.ie> <Pine.LNX.4.64.0706181022060.4751@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706181022060.4751@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/06/07 10:22), Christoph Lameter didst pronounce:
> You are amazing.
> 

Thanks! 

There are still knots that need ironing out but I believe the core idea
is solid and can be built into something useful.

Thanks for reviewing.

> Acked-by: Christoph Lameter <clameter@sgi.com>
> 

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
