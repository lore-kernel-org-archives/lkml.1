Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYCQG6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYCQG6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 02:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYCQG6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 02:58:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57971 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYCQG6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 02:58:01 -0400
Date: Mon, 17 Mar 2008 08:00:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Paul Jackson <pj@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [0/18] GB pages hugetlb support
Message-ID: <20080317070026.GB27015@one.firstfloor.org>
References: <20080317258.659191058@firstfloor.org> <20080316221132.7218743e.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080316221132.7218743e.pj@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2008 at 10:11:32PM -0500, Paul Jackson wrote:
> Andi,
> 
> Are all the "interesting" cpuset related changes in patch:
> 
>   [PATCH] [1/18] Convert hugeltlb.c over to pass global state around in a structure

That one and Add basic support for more than one hstate in hugetlbfs
and partly Add support to have individual hstates for each hugetlbfs mount
It all builds on each other.
Ideally look at the end result of the whole series.

-Andi
