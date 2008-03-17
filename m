Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYCQH1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYCQH1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 03:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbYCQH1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 03:27:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41022 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbYCQH1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 03:27:07 -0400
Date: Mon, 17 Mar 2008 08:29:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Paul Jackson <pj@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [0/18] GB pages hugetlb support
Message-ID: <20080317072931.GD27015@one.firstfloor.org>
References: <20080317258.659191058@firstfloor.org> <20080316221132.7218743e.pj@sgi.com> <20080317070026.GB27015@one.firstfloor.org> <20080317020018.2bf0b466.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080317020018.2bf0b466.pj@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 02:00:18AM -0500, Paul Jackson wrote:
> Andi wrote:
> > This was against 2.6.25-rc4 
> 
> Ok - I'll try that one.

I just updated to 2.6.25-rc6 base on 
ftp://firstfloor.org/pub/ak/gbpages/patches/
and gave it a quick test. So you can use that one too.

It only had a single easy reject.

-Andi
