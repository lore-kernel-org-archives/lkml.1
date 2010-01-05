Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317Ab0AETSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0AETSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657Ab0AETSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:18:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:56529 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab0AETSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:18:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,505,1257148800"; 
   d="scan'208";a="528689968"
Subject: Re: Xorg hangs on >= ~2.6.31 with Intel i915 driver
From: David Woodhouse <david.woodhouse@intel.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Anholt <eric@anholt.net>
In-Reply-To: <1262718168.7057.29.camel@nimitz>
References: <1262718168.7057.29.camel@nimitz>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Tue, 05 Jan 2010 19:18:37 +0000
Message-ID: <1262719117.3181.7223.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 19:02 +0000, Dave Hansen wrote:
> I've been seeing hangs when X starts up with newer kernels.  I sometimes
> get a cursor on the screen, sometimes not.  I can move the cursor when I
> can see it, but I can't switch to a text console.  Sysrq works.

http://bugzilla.kernel.org/show_bug.cgi?id=14627 ?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

