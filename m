Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZLBNPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZLBNPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZLBNPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:15:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53584 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbZLBNPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:15:43 -0500
Date: Wed, 2 Dec 2009 14:15:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/24] HWPOISON: introduce struct hwpoison_control
Message-ID: <20091202131550.GH18989@one.firstfloor.org>
References: <20091202031231.735876003@intel.com> <20091202043045.258152715@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202043045.258152715@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 11:12:44AM +0800, Wu Fengguang wrote:
> This allows passing around more parameters and states.
> No behavior change.

As mentioned earlier I'll skip this patch for now.
-Andi
