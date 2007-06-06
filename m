Return-Path: <linux-kernel-owner+w=401wt.eu-S936366AbXFFW3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936366AbXFFW3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935199AbXFFW3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:29:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:41115 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935124AbXFFW3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:29:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="236395416"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Wed, 6 Jun 2007 15:28:43 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706061229.24486.jesse.barnes@intel.com> <200706061524.52628.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061826260.5415@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706061826260.5415@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061528.44070.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 6, 2007 3:26 pm Justin Piszcz wrote:
> Nope, I booted with only netconsole= options.  I have a lot of HW in
> the box and I guess the buffer is too small.  Not sure where to
> change it in the kernel.  Looking..

It's called "kernel log buffer size" and it's in "General setup".

Jesse
