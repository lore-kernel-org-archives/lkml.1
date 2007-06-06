Return-Path: <linux-kernel-owner+w=401wt.eu-S935627AbXFFUbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935627AbXFFUbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933796AbXFFUbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:31:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:64224 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488AbXFFUbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:31:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="236354511"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Wed, 6 Jun 2007 13:31:30 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706061229.24486.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061626360.21038@p34.internal.lan> <200706061328.53443.jesse.barnes@intel.com>
In-Reply-To: <200706061328.53443.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061331.30516.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 6, 2007 1:28 pm Jesse Barnes wrote:
> > Against what kernel version does this patch apply?
>
> Um... git as of b4946ffb1860597b187d78d61ac6504177eb0ff8.  Sorry I
> should have updated before spinning the patch (will do now).

Appears to apply cleanly to git head as of a minute ago too.

Jesse
