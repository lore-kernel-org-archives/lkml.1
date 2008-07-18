Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYGROVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYGROVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYGROVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:21:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbYGROVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:21:13 -0400
Message-ID: <4880A694.1000100@linux-foundation.org>
Date: Fri, 18 Jul 2008 09:20:04 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: penberg@cs.helsinki.fi, mpm@selenic.com, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH][RFC] slub: increasing order reduces memory usage	of	some
 key caches
References: <1216211371.3122.46.camel@castor.localdomain>	 <487DF5D4.9070101@linux-foundation.org>	 <1216216730.3122.60.camel@castor.localdomain>	 <487DFFBE.5050407@linux-foundation.org> <1216375025.3082.7.camel@castor.localdomain>
In-Reply-To: <1216375025.3082.7.camel@castor.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kennedy wrote:

> Slabcache: radix_tree_node       Aliases:  0 Order :  1 Objects: 33564

Argh. Should this not be the dentry cache? Wrong numbers?


