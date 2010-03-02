Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab0CBBd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:33:59 -0500
Received: from mga10.intel.com ([192.55.52.92]:54186 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751745Ab0CBBd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:33:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,563,1262592000"; 
   d="scan'208";a="777066762"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH 0/7][v4] PV extension of HVM (Hybrid) for Xen
Date: Tue, 2 Mar 2010 09:34:56 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, linux-kernel@vger.kernel.org,
       "xen-devel" <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <201003020926.03512.sheng@linux.intel.com> <4B8C6AA4.8000700@goop.org>
In-Reply-To: <4B8C6AA4.8000700@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003020934.56614.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 March 2010 09:32:20 Jeremy Fitzhardinge wrote:
> On 03/01/2010 05:26 PM, Sheng Yang wrote:
> >> Why 2.6.33?  I'm currently working on 2.6.32; I intend to move to .33
> >> shortly, but .32 is a much more convenient base (particularly if you're
> >> interested in getting these changes into any distro kernels).
> >>
> >> I rebased it to .32 without much effort.
> >
> > OK.
> 
> Hm, looks like the x86_platform_ipi stuff is missing in .32.
> 
I thought that one should still called smp_generic_interrupt in .32?

-- 
regards
Yang, Sheng
