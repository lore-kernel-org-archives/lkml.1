Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbXIUSSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbXIUSSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbXIUSSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:18:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbXIUSSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:18:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: x86_64: potential critical issue with quicklists and page table pages
Date: Fri, 21 Sep 2007 20:18:41 +0200
User-Agent: KMail/1.9.6
Cc: torvalds@linux-foundation.org, clameter@sgi.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, tony.luck@intel.com,
       asit.k.mallick@intel.com
References: <20070921180742.GH20863@linux-os.sc.intel.com>
In-Reply-To: <20070921180742.GH20863@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212018.41643.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Can we revert this commit for 2.6.23 and look at this code post 2.6.23?

Fine by me to revert it. I must admit I never 100% understood how it was
supposed to work anyways, but eventually gave up on it.

-Andi
