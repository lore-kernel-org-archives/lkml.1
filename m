Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbZDXIO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbZDXIO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZDXIOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:14:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39382 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbZDXIOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:14:40 -0400
Date: Fri, 24 Apr 2009 10:18:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 4/4] PCI: PCIE AER: Document for PCIE AER software error injection
Message-ID: <20090424081821.GA13896@one.firstfloor.org>
References: <1240541131.6842.682.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240541131.6842.682.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ying,

On Fri, Apr 24, 2009 at 10:45:31AM +0800, Huang Ying wrote:
> This patch add a minimal HOWTO for PCIE AER software error injection
> in Documentation/PCI/pcieaer-howto.txt.

I reviewed the patches and they all look good to me.
I also think they're a valuable addition to Linux.

You can add a 

Reviewed-by: Andi Kleen <ak@linux.intel.com>

to the whole series.

-Andi

