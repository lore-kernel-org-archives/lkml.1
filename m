Return-Path: <linux-kernel-owner+w=401wt.eu-S1764019AbZLQIn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764019AbZLQIn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 03:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZLQIny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 03:43:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35701 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764121AbZLQInw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 03:43:52 -0500
Date: Thu, 17 Dec 2009 09:43:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: jbarnes@virtuousgeek.org, andrew.patterson@hp.com, andi@firstfloor.org,
       ying.huang@intel.com, kent.liu@intel.com, youquan.song@intel.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [Resend PATCH]PCIe AER: reject aer inject if hardware mask
	error reporting
Message-ID: <20091217084349.GD9804@basil.fritz.box>
References: <20091211234855.GB7196@youquan-linux.bj.intel.com> <1260836954.19155.84.camel@bluto.andrew> <20091217132248.GC11466@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217132248.GC11466@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 08:22:48AM -0500, Youquan,Song wrote:
> Correcteable/Uncorrectable Error Mask Register are used by PCIe AER driver 
> which will controls the reporting of idividual errors to PCIe RC via PCIe
> error messages. 
> 
> If hardware masks special error reporting to RC, the aer_inject driver should
>  not inject aer error.
> 
> Signed-off-by: Youquan, Song <youquan.song@intel.com>
> Acked-by: Ying, Huang <ying.huang@intel.com>

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
