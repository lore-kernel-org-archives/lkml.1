Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbZKOJzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbZKOJzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 04:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZKOJzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 04:55:45 -0500
Received: from mga14.intel.com ([143.182.124.37]:62931 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbZKOJzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 04:55:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,746,1249282800"; 
   d="scan'208";a="211649877"
Subject: Re: [regression] [drm:i915_gem_execbuffer] *ERROR* Execbuf while
 wedged
From: David Woodhouse <david.woodhouse@intel.com>
To: "schnitzelkuchen@googlemail.com" <schnitzelkuchen@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>
In-Reply-To: <200911151048.13777.schnitzelkuchen@googlemail.com>
References: <200911151048.13777.schnitzelkuchen@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Sun, 15 Nov 2009 09:55:48 +0000
Message-ID: <1258278948.1496.155.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-15 at 01:48 -0800, Michael wrote:
> 
> I tried 2.6.32-rc6 with my Dell Inspiron 1525, but the KDM didnt
> display right - It was mostly black with only the cursor displayed.
> Other things which use X dont work with the kernel, too. 

Interesting. Do you actually have an IOMMU, and is it enabled?


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

