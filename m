Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbZKTJnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbZKTJnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 04:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZKTJnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 04:43:24 -0500
Received: from mga07.intel.com ([143.182.124.22]:62680 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752410AbZKTJnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 04:43:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,776,1249282800"; 
   d="scan'208";a="213791979"
Date: Fri, 20 Nov 2009 10:45:11 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
       Balaji Rao <balajirrao@openmoko.org>
Subject: Re: [PATCH 0/5] pcf50633 - error handling & use threaded IRQs - v2
Message-ID: <20091120094510.GD3733@sortiz.org>
References: <20091116060611.20162.81714.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116060611.20162.81714.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Sun, Nov 15, 2009 at 10:08:37PM -0800, Dmitry Torokhov wrote:
> Hi Samuel,
> 
> Hopefully this is split enough to your liking. 
Looks much better, thanks.


> It should apply to for-next
> branch of mfd tree.
> 
> Compile-tested only, still don't have the hardwrae.
I applied it to my for-next branch. I'd appreciate if Lars or Balaji could
give it a try and report problems with it.

Cheers,
Samuel.


> -- 
> Dmitry

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
