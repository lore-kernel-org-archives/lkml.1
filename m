Return-Path: <linux-kernel-owner+w=401wt.eu-S1751181AbXBUIOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181AbXBUIOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 03:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXBUIOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 03:14:46 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:28144 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbXBUIOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 03:14:45 -0500
Date: Wed, 21 Feb 2007 10:14:43 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, clameter@sgi.com, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
Subject: Re: [PATCH 2/3] slab: export ksize to modules
Message-ID: <20070221081443.GC2857@rhun.haifa.ibm.com>
References: <Pine.LNX.4.64.0702211006210.8172@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702211006210.8172@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 10:06:52AM +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This exports ksize in slab and slob allocators to modules.

That's a pretty generic name... if it's going to be part of the module
API, it should be renamed to something a bit more obvious.

Cheers,
Muli
