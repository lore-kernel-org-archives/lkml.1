Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYCSTbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYCSTbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYCST0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:26:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52750 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbYCSTZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:25:19 -0400
Date: Tue, 18 Mar 2008 16:47:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, pj@sgi.com,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [7/18] Abstract out the NUMA node round robin code into a separate function
Message-ID: <20080318154707.GA23490@one.firstfloor.org>
References: <20080317258.659191058@firstfloor.org> <20080317015820.ECC861B41E0@basil.firstfloor.org> <20080318154209.GG23866@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318154209.GG23866@csn.ul.ie>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hmm, I'm not seeing where next_nid gets declared locally here as it
> should have been removed in an earlier patch. Maybe it's reintroduced

No there was no earlier patch touching this, so the old next_nid 
is still there.

-Andi
