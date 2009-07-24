Return-Path: <linux-kernel-owner+w=401wt.eu-S1751530AbZGXLcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbZGXLcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 07:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZGXLcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 07:32:09 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46584 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750870AbZGXLcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 07:32:08 -0400
Date: Fri, 24 Jul 2009 07:31:32 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, kosaki.motohiro@jp.fujitsu.com,
       maximlevitsky@gmail.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee.Schermerhorn@hp.com, penberg@cs.helsinki.fi,
       hannes@cmpxchg.org, jirislaby@gmail.com
Subject: Re: [PATCH] mm: Warn once when a page is freed with PG_mlocked set
 V2
In-Reply-To: <20090724103656.GA18074@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0907240731010.4073@gentwo.org>
References: <20090715125822.GB29749@csn.ul.ie> <alpine.DEB.1.10.0907151027410.23643@gentwo.org> <20090722160649.61176c61.akpm@linux-foundation.org> <20090723102938.GA27731@csn.ul.ie> <20090723102316.b94a2e4f.akpm@linux-foundation.org>
 <20090724103656.GA18074@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

