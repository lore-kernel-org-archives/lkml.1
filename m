Return-Path: <linux-kernel-owner+w=401wt.eu-S965073AbXCNFmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965073AbXCNFmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965047AbXCNFmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:42:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:49757 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025AbXCNFmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:42:18 -0400
Date: Tue, 13 Mar 2007 22:40:18 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: David Miller <davem@davemloft.net>, greg@kroah.com,
       linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org,
       stable@kernel.org, sparclinux@vger.kernel.org
Subject: Re: Linux 2.6.20.3
Message-ID: <20070314054018.GW18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Nish Aravamudan <nish.aravamudan@gmail.com>,
	David Miller <davem@davemloft.net>, greg@kroah.com,
	linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org,
	stable@kernel.org, sparclinux@vger.kernel.org
References: <20070313183353.GA7434@kroah.com> <29495f1d0703131457i43883529p5da1502b68ff0948@mail.gmail.com> <29495f1d0703131458j18f9aee1tcd9a2b2ff6ecdf41@mail.gmail.com> <20070313.152054.31641425.davem@davemloft.net> <29495f1d0703131551k5c06170bma138f8c1f1f9c84e@mail.gmail.com> <29495f1d0703131729y56a99d9cj15288e7c18e277a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29495f1d0703131729y56a99d9cj15288e7c18e277a8@mail.gmail.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 05:29:17PM -0700, Nish Aravamudan wrote:
> Ok, truly bizarre, I found that I was not running stock 2.6.20.3, but
> had your small hugetlb patch on top.
> So I went back and patched 2.6.20.1 with your patch, rebooted, got a
> soft lockup. Went back to stock 2.6.20.1 and did not.
> I don't see how your patch (C&P below for reference) could make any
> difference...Especially because no hugepages were in use at the time.
> On patched 2.6.20.1, I was just trying to check if my source tree had
> your patch applied (by `patch -p1 < davem.patch`) and got the
> soft-lockup I saw in 2.6.20.3 with the patch applied. I am going to
> try a clean 2.6.20.3 as well, now.

I'm still trying to get on this.


-- wli
